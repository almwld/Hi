/**
 * ============================================
 * routes/pharmacy.js - نظام الصيدلية والطلبات
 * ============================================
 *
 * نظام الصيدلية وطلب الأدوية
 * يشمل: الأدوية، الطلبات، التتبع، التقييم
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

// طلبات الصيدلية
const orders = new Map();

// بيانات الأدوية
const medications = {
    // مسكنات الألم
    'med-1': {
        id: 'med-1',
        name: 'باراسيتامول 500mg',
        genericName: 'Paracetamol',
        category: 'مسكنات الألم',
        description: 'مسكن للآلام وخافض للحرارة',
        price: 500,
        inStock: true,
        requiresPrescription: false,
        dosage: 'قرص كل 6 ساعات بعد الأكل',
        sideEffects: 'نادراً ما يسبب آثار جانبية',
        image: null
    },
    'med-2': {
        id: 'med-2',
        name: 'إيبوبروفين 400mg',
        genericName: 'Ibuprofen',
        category: 'مسكنات الألم',
        description: 'مضاد للالتهاب ومسكن للآلام',
        price: 800,
        inStock: true,
        requiresPrescription: false,
        dosage: 'قرص كل 8 ساعات بعد الأكل',
        sideEffects: 'قد يسبب اضطرابات في المعدة',
        image: null
    },
    // المضادات الحيوية
    'med-3': {
        id: 'med-3',
        name: 'أموكسيسيلين 500mg',
        genericName: 'Amoxicillin',
        category: 'المضادات الحيوية',
        description: 'مضاد حيوي واسع الطيف',
        price: 1500,
        inStock: true,
        requiresPrescription: true,
        dosage: 'كبسولة كل 8 ساعات لمدة 7 أيام',
        sideEffects: 'قد يسبب حساسية',
        image: null
    },
    'med-4': {
        id: 'med-4',
        name: 'أزيثرومايسين 500mg',
        genericName: 'Azithromycin',
        category: 'المضادات الحيوية',
        description: 'مضاد حيوي للعدوى التنفسية',
        price: 3500,
        inStock: true,
        requiresPrescription: true,
        dosage: 'قرص يومياً لمدة 3 أيام',
        sideEffects: 'قد يسبب غثيان وإسهال',
        image: null
    },
    // أدوية القلب
    'med-5': {
        id: 'med-5',
        name: 'أملوديبين 5mg',
        genericName: 'Amlodipine',
        category: 'أدوية القلب',
        description: 'لعلاج ضغط الدم المرتفع',
        price: 2000,
        inStock: true,
        requiresPrescription: true,
        dosage: 'قرص يومياً صباحاً',
        sideEffects: 'قد يسبب تورم في القدمين',
        image: null
    },
    // فيتامينات ومكملات
    'med-6': {
        id: 'med-6',
        name: 'فيتامين د3 1000IU',
        genericName: 'Vitamin D3',
        category: 'الفيتامينات',
        description: 'مكمل غذائي لصحة العظام',
        price: 1200,
        inStock: true,
        requiresPrescription: false,
        dosage: 'قرص يومياً',
        sideEffects: 'آمن عند الاستخدام الصحيح',
        image: null
    },
    // أدوية السكري
    'med-7': {
        id: 'med-7',
        name: 'ميتفورمين 500mg',
        genericName: 'Metformin',
        category: 'أدوية السكري',
        description: 'لعلاج السكري من النوع الثاني',
        price: 1000,
        inStock: true,
        requiresPrescription: true,
        dosage: 'قرص مرتين يومياً مع الأكل',
        sideEffects: 'قد يسبب اضطرابات هضمية',
        image: null
    },
    // أدوية الجهاز التنفسي
    'med-8': {
        id: 'med-8',
        name: 'مونتيلوكاست 10mg',
        genericName: 'Montelukast',
        category: 'أدوية الجهاز التنفسي',
        description: 'لعلاج الربو والحساسية',
        price: 2500,
        inStock: true,
        requiresPrescription: true,
        dosage: 'قرص يومياً مساءً',
        sideEffects: 'قد يسبب صداع',
        image: null
    }
};

// الصيدليات
const pharmacies = {
    'pharmacy-1': {
        id: 'pharmacy-1',
        name: 'صيدلية الرحمة',
        city: 'صنعاء',
        address: 'شارع الزبيري',
        phone: '0111222333',
        rating: 4.6,
        deliveryAvailable: true,
        deliveryAreas: ['صنعاء', 'عدن', 'تعز'],
        workingHours: { open: 8, close: 22 },
        image: null
    },
    'pharmacy-2': {
        id: 'pharmacy-2',
        name: 'صيدلية الشفاء',
        city: 'عدن',
        address: 'شارع خليفة',
        phone: '0111222444',
        rating: 4.4,
        deliveryAvailable: true,
        deliveryAreas: ['عدن', 'تعز'],
        workingHours: { open: 9, close: 21 },
        image: null
    },
    'pharmacy-3': {
        id: 'pharmacy-3',
        name: 'صيدلية النور',
        city: 'تعز',
        address: 'شارع المدمر',
        phone: '0111222555',
        rating: 4.3,
        deliveryAvailable: false,
        deliveryAreas: ['تعز'],
        workingHours: { open: 8, close: 20 },
        image: null
    }
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * تنسيق الطلب
 */
function formatOrder(order) {
    const pharmacy = pharmacies[order.pharmacyId];
    const orderItems = order.items.map(item => ({
        ...item,
        medication: medications[item.medicationId] || null
    }));

    return {
        id: order.id,
        orderNumber: order.orderNumber,
        patientId: order.patientId,
        pharmacyId: order.pharmacyId,
        pharmacy: pharmacy || null,
        items: orderItems,
        totalAmount: order.totalAmount,
        status: order.status,
        deliveryAddress: order.deliveryAddress,
        deliveryPhone: order.deliveryPhone,
        notes: order.notes,
        estimatedDeliveryTime: order.estimatedDeliveryTime,
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
    return `ORD-${timestamp}-${random}`;
}

// ============================================
// Routes - الأدوية
// ============================================

/**
 * GET /api/pharmacy/medications
 * جلب قائمة الأدوية
 */
router.get('/medications', (req, res) => {

/**
 * GET /api/pharmacy/medications/categories
 * جلب التصنيفات
 */
router.get("/medications/categories", (req, res) => {
  try {
    const categories = [...new Set(Object.values(medications).map(m => m.category))];
    res.status(200).json({ success: true, categories });
  } catch (error) {
    res.status(500).json({ success: false, error: "حدث خطأ" });
  }
});

    try {
        const { category, search, inStock, requiresPrescription } = req.query;

        let filteredMedications = Object.values(medications);

        // تصفية حسب التصنيف
        if (category) {
            filteredMedications = filteredMedications.filter(m =>
                m.category.toLowerCase().includes(category.toLowerCase())
            );
        }

        // البحث
        if (search) {
            const searchLower = search.toLowerCase();
            filteredMedications = filteredMedications.filter(m =>
                m.name.toLowerCase().includes(searchLower) ||
                m.genericName.toLowerCase().includes(searchLower) ||
                m.description.toLowerCase().includes(searchLower)
            );
        }

        // تصفية حسب التوفر
        if (inStock === 'true') {
            filteredMedications = filteredMedications.filter(m => m.inStock);
        }

        // تصفية حسب وصفة طبية
        if (requiresPrescription === 'true') {
            filteredMedications = filteredMedications.filter(m => m.requiresPrescription);
        }

        res.status(200).json({
            success: true,
            medications: filteredMedications,
            total: filteredMedications.length
        });

    } catch (error) {
        console.error('[Pharmacy] Get Medications Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/pharmacy/medications/:id
 * جلب بيانات دواء معين
 */
router.get('/medications/categories', (req, res) => {
    try {
        const categories = [...new Set(Object.values(medications).map(m => m.category))];

        res.status(200).json({
            success: true,
            categories
        });

    } catch (error) {
        console.error('[Pharmacy] Get Categories Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

// ============================================
// Routes - الصيدليات
// ============================================

/**
 * GET /api/pharmacy/pharmacies
 * جلب قائمة الصيدليات
 */
router.get('/pharmacies', (req, res) => {
    try {
        const { city, search, deliveryAvailable } = req.query;

        let filteredPharmacies = Object.values(pharmacies);

        // تصفية حسب المدينة
        if (city) {
            filteredPharmacies = filteredPharmacies.filter(p =>
                p.city.toLowerCase().includes(city.toLowerCase())
            );
        }

        // البحث
        if (search) {
            const searchLower = search.toLowerCase();
            filteredPharmacies = filteredPharmacies.filter(p =>
                p.name.toLowerCase().includes(searchLower) ||
                p.address.toLowerCase().includes(searchLower)
            );
        }

        // تصفية حسب التوصيل
        if (deliveryAvailable === 'true') {
            filteredPharmacies = filteredPharmacies.filter(p => p.deliveryAvailable);
        }

        res.status(200).json({
            success: true,
            pharmacies: filteredPharmacies,
            total: filteredPharmacies.length
        });

    } catch (error) {
        console.error('[Pharmacy] Get Pharmacies Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/pharmacy/pharmacies/:id
 * جلب بيانات صيدلية معينة
 */
router.get('/pharmacies/:id', (req, res) => {
    try {
        const pharmacy = pharmacies[req.params.id];

        if (!pharmacy) {
            return res.status(404).json({
                success: false,
                error: 'الصيدلية غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        // جلب الأدوية المتوفرة في هذه الصيدلية
        const availableMedications = Object.values(medications).filter(m => m.inStock);

        res.status(200).json({
            success: true,
            pharmacy,
            availableMedications
        });

    } catch (error) {
        console.error('[Pharmacy] Get Pharmacy Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

// ============================================
// Routes - الطلبات
// ============================================

/**
 * GET /api/pharmacy/orders
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

        let filteredOrders = Array.from(orders.values())
            .filter(order => order.patientId === patientId);

        // تصفية حسب الحالة
        if (status) {
            filteredOrders = filteredOrders.filter(order => order.status === status);
        }

        // ترتيب حسب التاريخ
        filteredOrders.sort((a, b) => b.createdAt - a.createdAt);

        res.status(200).json({
            success: true,
            orders: filteredOrders.map(formatOrder),
            total: filteredOrders.length
        });

    } catch (error) {
        console.error('[Pharmacy] Get Orders Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/pharmacy/orders/:id
 * جلب بيانات طلب معين
 */
router.get('/orders/:id', (req, res) => {
    try {
        const order = orders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        res.status(200).json({
            success: true,
            order: formatOrder(order)
        });

    } catch (error) {
        console.error('[Pharmacy] Get Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/pharmacy/orders
 * إنشاء طلب جديد
 */
router.post('/orders', (req, res) => {
    try {
        const {
            patientId,
            pharmacyId,
            items,
            deliveryAddress,
            deliveryPhone,
            notes
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!patientId || !pharmacyId || !items || items.length === 0) {
            return res.status(400).json({
                success: false,
                error: 'البيانات المطلوبة ناقصة',
                code: 'MISSING_FIELDS'
            });
        }

        // التحقق من الصيدلية
        const pharmacy = pharmacies[pharmacyId];
        if (!pharmacy) {
            return res.status(404).json({
                success: false,
                error: 'الصيدلية غير موجودة',
                code: 'PHARMACY_NOT_FOUND'
            });
        }

        // التحقق من الأدوية
        let totalAmount = 0;
        const orderItems = [];

        for (const item of items) {
            const medication = medications[item.medicationId];
            if (!medication) {
                return res.status(404).json({
                    success: false,
                    error: `الدواء ${item.medicationId} غير موجود`,
                    code: 'MEDICATION_NOT_FOUND'
                });
            }

            if (!medication.inStock) {
                return res.status(400).json({
                    success: false,
                    error: `الدواء ${medication.name} غير متوفر`,
                    code: 'OUT_OF_STOCK'
                });
            }

            const quantity = item.quantity || 1;
            const itemPrice = medication.price * quantity;
            totalAmount += itemPrice;

            orderItems.push({
                medicationId: item.medicationId,
                quantity,
                priceAtOrder: medication.price,
                totalPrice: itemPrice
            });
        }

        // إنشاء الطلب
        const orderId = uuidv4();
        const order = {
            id: orderId,
            orderNumber: generateOrderNumber(),
            patientId,
            pharmacyId,
            items: orderItems,
            totalAmount,
            status: 'pending',
            deliveryAddress: deliveryAddress || null,
            deliveryPhone: deliveryPhone || null,
            notes: notes || null,
            estimatedDeliveryTime: pharmacy.deliveryAvailable ? 60 : 30, // دقائق
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        orders.set(orderId, order);

        res.status(201).json({
            success: true,
            message: 'تم إنشاء الطلب بنجاح',
            order: formatOrder(order)
        });

    } catch (error) {
        console.error('[Pharmacy] Create Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/pharmacy/orders/:id
 * تحديث حالة الطلب
 */
router.put('/orders/:id', (req, res) => {
    try {
        const { status, notes } = req.body;
        const order = orders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        if (status) order.status = status;
        if (notes !== undefined) order.notes = notes;
        order.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم تحديث الطلب',
            order: formatOrder(order)
        });

    } catch (error) {
        console.error('[Pharmacy] Update Order Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * DELETE /api/pharmacy/orders/:id
 * إلغاء الطلب
 */
router.delete('/orders/:id', (req, res) => {
    try {
        const order = orders.get(req.params.id);

        if (!order) {
            return res.status(404).json({
                success: false,
                error: 'الطلب غير موجود',
                code: 'NOT_FOUND'
            });
        }

        if (order.status === 'delivered' || order.status === 'cancelled') {
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
            order: formatOrder(order)
        });

    } catch (error) {
        console.error('[Pharmacy] Cancel Order Error:', error);
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