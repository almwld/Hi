/**
 * ============================================
 * routes/reviews.js - نظام التقييم والمراجعات
 * ============================================
 *
 * نظام تقييم الأطباء والمراجعات
 * يشمل: تقييم، مراجعات، ردود
 *
 * @author Sehatak Team
 * @version 2.0.0
 */

const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');

// ============================================
// تخزين مؤقت
// ============================================

// التقييمات والمراجعات
const reviews = new Map();

// إحصائيات التقييمات
const reviewStats = {
    'doctor-1': { totalReviews: 45, averageRating: 4.8, ratingDistribution: { 5: 35, 4: 8, 3: 2, 2: 0, 1: 0 } },
    'doctor-2': { totalReviews: 32, averageRating: 4.9, ratingDistribution: { 5: 28, 4: 4, 3: 0, 2: 0, 1: 0 } },
    'doctor-3': { totalReviews: 28, averageRating: 4.7, ratingDistribution: { 5: 20, 4: 6, 3: 2, 2: 0, 1: 0 } }
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * تنسيق المراجعة
 */
function formatReview(review) {
    return {
        id: review.id,
        doctorId: review.doctorId,
        patientId: review.patientId,
        patientName: review.patientName || 'مستخدم',
        rating: review.rating,
        title: review.title,
        content: review.content,
        pros: review.pros || [],
        cons: review.cons || [],
        response: review.response || null,
        helpfulCount: review.helpfulCount || 0,
        createdAt: review.createdAt,
        updatedAt: review.updatedAt
    };
}

/**
 * حساب متوسط التقييم
 */
function calculateAverageRating(doctorId) {
    const doctorReviews = Array.from(reviews.values())
        .filter(r => r.doctorId === doctorId && r.status === 'approved');

    if (doctorReviews.length === 0) {
        return 0;
    }

    const sum = doctorReviews.reduce((acc, r) => acc + r.rating, 0);
    return (sum / doctorReviews.length).toFixed(1);
}

// ============================================
// Routes
// ============================================

/**
 * GET /api/reviews/doctor/:doctorId
 * جلب مراجعات طبيب معين
 */
router.get('/doctor/:doctorId', (req, res) => {
    try {
        const { doctorId } = req.params;
        const { sort = 'newest', limit = 20 } = req.query;

        let doctorReviews = Array.from(reviews.values())
            .filter(r => r.doctorId === doctorId);

        // الترتيب
        switch (sort) {
            case 'oldest':
                doctorReviews.sort((a, b) => a.createdAt - b.createdAt);
                break;
            case 'highest':
                doctorReviews.sort((a, b) => b.rating - a.rating);
                break;
            case 'lowest':
                doctorReviews.sort((a, b) => a.rating - b.rating);
                break;
            case 'helpful':
                doctorReviews.sort((a, b) => b.helpfulCount - a.helpfulCount);
                break;
            default: // newest
                doctorReviews.sort((a, b) => b.createdAt - a.createdAt);
        }

        // تحديد العدد
        doctorReviews = doctorReviews.slice(0, parseInt(limit));

        // إحصائيات التقييم
        const stats = reviewStats[doctorId] || {
            totalReviews: doctorReviews.length,
            averageRating: calculateAverageRating(doctorId),
            ratingDistribution: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }
        };

        res.status(200).json({
            success: true,
            reviews: doctorReviews.map(formatReview),
            stats: {
                ...stats,
                averageRating: parseFloat(stats.averageRating) || calculateAverageRating(doctorId)
            },
            total: doctorReviews.length
        });

    } catch (error) {
        console.error('[Reviews] Get Doctor Reviews Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/reviews/stats/:doctorId
 * جلب إحصائيات التقييم
 */
router.get('/stats/:doctorId', (req, res) => {
    try {
        const { doctorId } = req.params;

        const stats = reviewStats[doctorId] || {
            totalReviews: 0,
            averageRating: 0,
            ratingDistribution: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }
        };

        res.status(200).json({
            success: true,
            doctorId,
            stats: {
                ...stats,
                averageRating: parseFloat(stats.averageRating) || calculateAverageRating(doctorId)
            }
        });

    } catch (error) {
        console.error('[Reviews] Get Stats Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/reviews
 * إضافة مراجعة جديدة
 */
router.post('/', (req, res) => {
    try {
        const {
            doctorId,
            patientId,
            patientName,
            rating,
            title,
            content,
            pros,
            cons
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!doctorId || !patientId || !rating) {
            return res.status(400).json({
                success: false,
                error: 'البيانات المطلوبة ناقصة',
                code: 'MISSING_FIELDS'
            });
        }

        // التحقق من التقييم
        if (rating < 1 || rating > 5) {
            return res.status(400).json({
                success: false,
                error: 'التقييم يجب أن يكون بين 1 و 5',
                code: 'INVALID_RATING'
            });
        }

        // التحقق من عدم وجود مراجعة سابقة
        const existingReview = Array.from(reviews.values()).find(
            r => r.doctorId === doctorId && r.patientId === patientId
        );

        if (existingReview) {
            return res.status(400).json({
                success: false,
                error: 'لقد قمت بإضافة مراجعة سابقاً لهذا الطبيب',
                code: 'REVIEW_EXISTS'
            });
        }

        // إنشاء المراجعة
        const reviewId = uuidv4();
        const review = {
            id: reviewId,
            doctorId,
            patientId,
            patientName: patientName || 'مستخدم مجهول',
            rating,
            title: title || null,
            content: content || null,
            pros: pros || [],
            cons: cons || [],
            response: null,
            helpfulCount: 0,
            status: 'approved', // approved, pending, rejected
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        reviews.set(reviewId, review);

        // تحديث الإحصائيات
        if (reviewStats[doctorId]) {
            reviewStats[doctorId].totalReviews++;
            reviewStats[doctorId].ratingDistribution[rating]++;
            // إعادة حساب المتوسط
            const total = Object.entries(reviewStats[doctorId].ratingDistribution)
                .reduce((acc, [star, count]) => acc + (parseInt(star) * count), 0);
            reviewStats[doctorId].averageRating = (total / reviewStats[doctorId].totalReviews).toFixed(1);
        } else {
            reviewStats[doctorId] = {
                totalReviews: 1,
                averageRating: rating.toFixed(1),
                ratingDistribution: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }
            };
            reviewStats[doctorId].ratingDistribution[rating] = 1;
        }

        res.status(201).json({
            success: true,
            message: 'تم إضافة المراجعة بنجاح',
            review: formatReview(review)
        });

    } catch (error) {
        console.error('[Reviews] Create Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/reviews/:id/helpful
 * وضع علامة "مفيد"
 */
router.put('/:id/helpful', (req, res) => {
    try {
        const review = reviews.get(req.params.id);

        if (!review) {
            return res.status(404).json({
                success: false,
                error: 'المراجعة غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        review.helpfulCount++;
        review.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم وضع علامة مفيد',
            review: formatReview(review)
        });

    } catch (error) {
        console.error('[Reviews] Helpful Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/reviews/:id/response
 * إضافة رد من الطبيب
 */
router.post('/:id/response', (req, res) => {
    try {
        const { response } = req.body;
        const review = reviews.get(req.params.id);

        if (!review) {
            return res.status(404).json({
                success: false,
                error: 'المراجعة غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        if (!response) {
            return res.status(400).json({
                success: false,
                error: 'الرد مطلوب',
                code: 'RESPONSE_REQUIRED'
            });
        }

        review.response = {
            content: response,
            createdAt: Date.now()
        };
        review.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم إضافة الرد',
            review: formatReview(review)
        });

    } catch (error) {
        console.error('[Reviews] Response Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * DELETE /api/reviews/:id
 * حذف مراجعة
 */
router.delete('/:id', (req, res) => {
    try {
        const review = reviews.get(req.params.id);

        if (!review) {
            return res.status(404).json({
                success: false,
                error: 'المراجعة غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        // تحديث الإحصائيات
        if (reviewStats[review.doctorId]) {
            reviewStats[review.doctorId].totalReviews--;
            reviewStats[review.doctorId].ratingDistribution[review.rating]--;

            // إعادة حساب المتوسط
            if (reviewStats[review.doctorId].totalReviews > 0) {
                const total = Object.entries(reviewStats[review.doctorId].ratingDistribution)
                    .reduce((acc, [star, count]) => acc + (parseInt(star) * count), 0);
                reviewStats[review.doctorId].averageRating = (total / reviewStats[review.doctorId].totalReviews).toFixed(1);
            } else {
                reviewStats[review.doctorId].averageRating = '0';
            }
        }

        reviews.delete(req.params.id);

        res.status(200).json({
            success: true,
            message: 'تم حذف المراجعة'
        });

    } catch (error) {
        console.error('[Reviews] Delete Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

// ============================================
// تصدير
// ============================================

module.exports = router;