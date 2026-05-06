/**
 * ============================================
 * routes/labs.js - نظام التحاليل المخبرية
 * ============================================
 *
 * نظام حجز وتحليل نتائج التحاليل المخبرية
 * يشمل: التحاليل، النتائج، الحجوزات
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

// طلبات التحاليل
const labOrders = new Map();

// بيانات التحاليل المخبرية
const tests = {
    'test-1': {
        id: 'test-1',
        name: 'تحليل صورة الدم الكاملة (CBC)',
        category: 'تحاليل الدم',
        description: 'تحليل شامل لخلايا الدم',
        price: 3000,
        duration: 30, // دقائق للحصول على النتيجة
        preparation: 'الصيام 8-12 ساعة',
        parameters: ['خلايا الدم البيضاء', 'خلايا الدم الحمراء', 'الصفائح الدموية', 'الهيموغلوبين']
    },
    'test-2': {
        id: 'test-2',
        name: 'فحص سكر الدم (Fasting Blood Sugar)',
        category: 'تحاليل السكري',
        description: 'قياس مستوى السكر في الدم',
        price: 1500,
        duration: 15,
        preparation: 'الصيام 8-12 ساعة',
        parameters: ['مستوى السكر الصيامي']
    },
    'test-3': {
        id: 'test-3',
        name: 'وظائف الكلى (Kidney Function)',
        category: 'تحاليل الكلى',
        description: 'فحص وظائف الكلى',
        price: 5000,
        duration: 60,
        preparation: 'لا يحتاج صيام',
        parameters: ['الكرياتينين', 'اليوريا', 'حمض اليوريك']
    },
    'test-4': {
        id: 'test-4',
        name: 'وظائف الكبد (Liver Function)',
        category: 'تحاليل الكبد',
        description: 'فحص وظائف الكبد',
        price: 5000,
        duration: 60,
        preparation: 'الصيام 8-12 ساعة',
        parameters: ['ALT', 'AST', 'Bilirubin', 'ALP']
    },
    'test-5': {
        id: 'test-5',
        name: 'فحص الدهون (Lipid Profile)',
        category: 'تحاليل الدهون',
        description: 'فحص مستوى الدهون في الدم',
        price: 4000,
        duration: 45,
        preparation: 'الصيام 12 ساعة',
        parameters: ['الكوليسترول', 'الدهون الثلاثية', 'HDL', 'LDL']
    },
    'test-6': {
        id: 'test-6',
        name: 'هرمون الغدة الدرقية (TSH)',
        category: 'تحاليل الهرمونات',
        description: 'فحص هرمون الغدة الدرقية',
        price: 6000,
        duration: 60,
        preparation: 'لا يحتاج صيام',
        parameters: ['TSH']
    },
    'test-7': {
        id: 'test-7',
        name: 'تحليل البول (Urinalysis)',
        category: 'تحاليل البول',
        description: 'تحليل شامل للبول',
        price: 1500,
        duration: 20,
        preparation: 'جمع عينة بول الصباح',
        parameters: ['اللون', 'ال透明度', 'pH', 'البروتين', 'السكر', 'الخلايا']
    },
    'test-8': {
        id: 'test-8',
        name: 'التهاب الكبد B (HBs Ag)',
        category: 'تحاليل الأمراض المعدية',
        description: 'فحص التهاب الكبد B',
        price: 4500,
        duration: 60,
        preparation: 'لا يحتاج صيام',
        parameters: ['HBs Ag']
    },
    'test-9': {
        id: 'test-9',
        name: 'فيروس نقص المناعة (HIV)',
        category: 'تحاليل الأمراض المعدية',
        description: 'فحص فيروس نقص المناعة',
        price: 5000,
        duration: 60,
        preparation: 'لا يحتاج صيام',
        parameters: ['HIV 1/2']
    },
    'test-10': {
        id: 'test-10',
        name: 'Vitamin D',
        category: 'تحاليل الفيتامينات',
        description: 'فحص مستوى فيتامين D',
        price: 7000,
        duration: 60,
        preparation: 'لا يحتاج صيام',
        parameters: ['Vitamin D']
    }
};

// المعامل
const labs = {
    'lab-1': {
        id: 'lab-1',
        name: 'مختبر الرحمة التشخيصي',
        city: 'صنعاء',
        address: 'شارع الزبيري',
        phone: '0111222333',
        rating: 4.7,
        accreditation: 'ISO 15189',
        workingHours: { open: 7, close: 20 },
        homeSampling: true,
        availableTests: ['test-1', 'test-2', 'test-3', 'test-4', 'test-5', 'test-6', 'test-7'],
        image: null
    },
    'lab-2': {
        id: 'lab-2',
        name: 'مختبر الشفاء التخصصي',
        city: 'عدن',
        address: 'شارع خليفة',
        phone: '0111222444',
        rating: 4.5,
        accreditation: 'ISO 9001',
        workingHours: { open: 8, close: 18 },
        homeSampling: true,
        availableTests: ['test-1', 'test-2', 'test-3', 'test-4', 'test-5', 'test-6', 'test-8', 'test-9'],
        image: null
    },
    'lab-3': {
        id: 'lab-3',
        name: 'مختبر النور للتحليلات',
        city: 'تعز',
        address: 'شارع المدمر',
        phone: '0111222555',
        rating: 4.3,
        accreditation: null,
        workingHours: { open: 7, close: 17 },
        homeSampling: false,
        availableTests: ['test-1', 'test-2', 'test-3', 'test-7'],
        image: null
    }
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * تنسيق طلب التحليل
 */
function formatLabOrder(order) {
    const lab = labs[order.labId];
    const orderTests = order.tests.map(testId => ({
        testId,
        test: tests[testId] || null
    }));

    return {
        id: order.id,
        orderNumber: order.orderNumber,
        patientId: order.patientId,
        labId: order.labId,
        lab: lab || null,
        tests: orderTests,
        totalAmount: order.totalAmount,
        status: order.status,
        sampleCollectionDate: order.sampleCollectionDate,
        sampleCollectionAddress: order.sampleCollectionAddress,
        results: order.results,
        notes: order.notes,
        createdAt: order.createdAt,
        updatedAt: order.updatedAt
    };
}

/**
 * توليد رقم الطلب
 */
function generateOrderNumber() {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = Math.random().toString(36).substring(2, 6).toUpperCase();
    return `LAB-${timestamp}-${random}`;
}

// ============================================
// Routes - التحاليل
// ============================================

/**
 * GET /api/labs/tests
 * جلب قائمة التحاليل
 */
router.get('/tests', (req, res) => {
    try {
        const { category, search } = req.query;

        let filteredTests = Object.values(tests);

        if (category) {
            filteredTests = filteredTests.filter(t =>
                t.category.toLowerCase().includes(category.toLowerCase())
            );
        }

        if (search) {
            const searchLower = search.toLowerCase();
            filteredTests = filteredTests.filter(t =>
                t.name.toLowerCase().includes(searchLower) ||
                t.description.toLowerCase().includes(searchLower)
            );
        }

        res.status(200).json({
            success: true,
            tests: filteredTests,
            total: filteredTests.length
        });

    } catch (error) {
        console.error('[Labs] Get Tests Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/labs/tests/:id
 * جلب بيانات تحليل معين
 */
router.get('/tests/:id', (req, res) => {
    try {
        const test = tests[req.params.id];

        if (!test) {
            return res.status(404).json({
                success: false,
                error: 'التحليل غير موجود',
                code: 'NOT_FOUND'
            });
        }

        res.status(200).json({
            success: true,
            test
        });

    } catch (error) {
        console.error('[Labs] Get Test Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/labs/tests/categories
 * جلب التصنيفات
 */
router.get('/tests/categories', (req, res) => {
    try {
        const categories = [...new Set(Object.values(tests).map(t => t.category))];

        res.status(200).json({
            success: true,
            categories
        });

    } catch (error) {
        console.error('[Labs] Get Categories Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

// ============================================
// Routes - المعامل
// ============================================

/**
 * GET /api/labs/labs
 * جلب قائمة المعامل
 */
router.get('/labs', (req, res) => {
    try {
        const { city, search, homeSampling } = req.query;

        let filteredLabs = Object.values(labs);

        if (city) {
            filteredLabs = filteredLabs.filter(l =>
                l.city.toLowerCase().includes(city.toLowerCase())
            );
        }

        if (search) {
            const searchLower = search.toLowerCase();
            filteredLabs = filteredLabs.filter(l =>
                l.name.toLowerCase().includes(searchLower) ||
                l.address.toLowerCase().includes(searchLower)
            );
        }

        if (homeSampling === 'true') {
            filteredLabs = filteredLabs.filter(l => l.homeSampling);
        }

        res.status(200).json({
            success: true,
            labs: filteredLabs,
            total: filteredLabs.length
        });

    } catch (error) {
        console.error('[Labs] Get Labs Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/labs/labs/:id
 * جلب بيانات معمل معين
 */
router.get('/labs/:id', (req, res) => {
    try {
        const lab = labs[req.params.id];

        if (!lab) {
            return res.status(404).json({
                success: false,
                error: 'المعمل غير موجود',
                code: 'NOT_FOUND'
            });
        }

        // جلب التحاليل المتوفرة
        const availableTests = lab.availableTests.map(testId => tests[testId]).filter(t => t);

        res.status(200).json({
            success: true,
            lab,
            availableTests
        });

    } catch (error) {
        console.error('[Labs] Get Lab Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

// ============================================
// Routes - طلبات التحاليل
// ============================================

/**
 * GET /api/labs/orders
 * جلب طلبات المريض
 */
router.get('/orders', (req, res) => {
    try {
        const { patientId, status } = req.query;

        if (!patientId) {
            return res.status(400).json({
                success: false,
                error: 'معرف المريض مطلوب',
                code: 'PATIENT_ID_REQUIRED'
            });
        }

        let filteredOrders = Array.from(labOrders.values())
            .filter(order => order.patientId === patientId);

        if (status) {
            filteredOrders = filteredOrders.filter(order => order.status === status);
        }

        filteredOrders.sort((a, b) => b.createdAt - a.createdAt);

        res.status(200).json({
            success: true,
            orders: filteredOrders.map(formatLabOrder),
            total: filteredOrders.length
        });

    } catch (error) {
        console.error('[Labs] Get Orders Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/labs/orders/:id
 * جلب بيانات طلب معين
 */
router.get('/orders/:id', (req, res) => {
    try {
        const order = labOrders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        res.status(200).json({
            success: true,
            order: formatLabOrder(order)
        });

    } catch (error) {
        console.error('[Labs] Get Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/labs/orders
 * إنشاء طلب تحليل جديد
 */
router.post('/orders', (req, res) => {
    try {
        const {
            patientId,
            labId,
            tests: testIds,
            sampleCollectionDate,
            sampleCollectionAddress,
            notes
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!patientId || !labId || !testIds || testIds.length === 0) {
            return res.status(400).json({
                success: false,
                error: 'البيانات المطلوبة ناقصة',
                code: 'MISSING_FIELDS'
            });
        }

        // التحقق من المعمل
        const lab = labs[labId];
        if (!lab) {
            return res.status(404).json({
                success: false,
                error: 'المعمل غير موجود',
                code: 'LAB_NOT_FOUND'
            });
        }

        // التحقق من التحاليل
        let totalAmount = 0;
        const orderTests = [];

        for (const testId of testIds) {
            const test = tests[testId];
            if (!test) {
                return res.status(404).json({
                    success: false,
                    error: `التحليل ${testId} غير موجود`,
                    code: 'TEST_NOT_FOUND'
                });
            }

            if (!lab.availableTests.includes(testId)) {
                return res.status(400).json({
                    success: false,
                    error: `التحليل ${test.name} غير متوفر في هذا المعمل`,
                    code: 'TEST_NOT_AVAILABLE'
                });
            }

            totalAmount += test.price;
            orderTests.push(testId);
        }

        // إنشاء الطلب
        const orderId = uuidv4();
        const order = {
            id: orderId,
            orderNumber: generateOrderNumber(),
            patientId,
            labId,
            tests: orderTests,
            totalAmount,
            status: 'pending',
            sampleCollectionDate: sampleCollectionDate || new Date().toISOString(),
            sampleCollectionAddress: sampleCollectionAddress || null,
            results: null,
            notes: notes || null,
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        labOrders.set(orderId, order);

        res.status(201).json({
            success: true,
            message: 'تم إنشاء الطلب بنجاح',
            order: formatLabOrder(order)
        });

    } catch (error) {
        console.error('[Labs] Create Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/labs/orders/:id
 * تحديث حالة الطلب
 */
router.put('/orders/:id', (req, res) => {
    try {
        const { status, results, notes } = req.body;
        const order = labOrders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        if (status) order.status = status;
        if (results) order.results = results;
        if (notes !== undefined) order.notes = notes;
        order.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم تحديث الطلب',
            order: formatLabOrder(order)
        });

    } catch (error) {
        console.error('[Labs] Update Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * DELETE /api/labs/orders/:id
 * إلغاء الطلب
 */
router.delete('/orders/:id', (req, res) => {
    try {
        const order = labOrders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        if (order.status === 'completed' || order.status === 'cancelled') {
            return res.status(400).json({
                success: false,
                error: 'لا يمكن إلغاء هذا الطلب',
                code: 'CANNOT_CANCEL'
            });
        }

        order.status = 'cancelled';
        order.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم إلغاء الطلب',
            order: formatLabOrder(order)
        });

    } catch (error) {
        console.error('[Labs] Cancel Order Error:', error);
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