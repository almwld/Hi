/**
 * ============================================
 * routes/payments.js - نظام المدفوعات
 * ============================================
 *
 * نظام المدفوعات والمحافظ اليمنية
 * يدعم: فلوسك، كاش، جوالي، جيب، إيزي
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

// المدفوعات
const payments = new Map();

// المحافظ المدعومة
const supportedWallets = {
    'flossk': {
        id: 'flossk',
        name: 'فلوسك',
        logo: null,
        minAmount: 100,
        maxAmount: 500000,
        fees: 0 // بدون عمولة
    },
    'cash': {
        id: 'cash',
        name: 'كاش',
        logo: null,
        minAmount: 0,
        maxAmount: 10000000,
        fees: 0
    },
    'jawali': {
        id: 'jawali',
        name: 'جوالي',
        logo: null,
        minAmount: 100,
        maxAmount: 500000,
        fees: 0
    },
    'jib': {
        id: 'jib',
        name: 'جيب',
        logo: null,
        minAmount: 100,
        maxAmount: 1000000,
        fees: 0
    },
    'easy': {
        id: 'easy',
        name: 'إيزي',
        logo: null,
        minAmount: 100,
        maxAmount: 500000,
        fees: 0
    }
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * توليد معرف العملية
 */
function generateTransactionId() {
    const timestamp = Date.now().toString(36);
    const random = Math.random().toString(36).substring(2, 8);
    return `TXN-${timestamp}-${random}`.toUpperCase();
}

/**
 * تنسيق المدفوعات
 */
function formatPayment(payment) {
    return {
        id: payment.id,
        transactionId: payment.transactionId,
        patientId: payment.patientId,
        orderId: payment.orderId || null,
        appointmentId: payment.appointmentId || null,
        amount: payment.amount,
        currency: 'YER', // ريال يمني
        walletType: payment.walletType,
        status: payment.status, // pending, processing, completed, failed, refunded
        paymentMethod: payment.paymentMethod,
        transactionRef: payment.transactionRef,
        metadata: payment.metadata,
        createdAt: payment.createdAt,
        updatedAt: payment.updatedAt
    };
}

/**
 * التحقق من مبلغ الدفع
 */
function validateAmount(amount, walletType) {
    const wallet = supportedWallets[walletType];
    if (!wallet) {
        return { valid: false, error: 'نوع المحفظة غير مدعوم' };
    }

    if (amount < wallet.minAmount) {
        return { valid: false, error: `الحد الأدنى للدفع هو ${wallet.minAmount} ${wallet.minAmount > 0 ? 'ريال' : ''}` };
    }

    if (amount > wallet.maxAmount) {
        return { valid: false, error: `الحد الأقصى للدفع هو ${wallet.maxAmount} ريال` };
    }

    return { valid: true };
}

// ============================================
// Routes
// ============================================

/**
 * GET /api/payments/wallets
 * جلب المحافظ المدعومة
 */
router.get('/wallets', (req, res) => {
    try {
        res.status(200).json({
            success: true,
            wallets: Object.values(supportedWallets)
        });

    } catch (error) {
        console.error('[Payments] Get Wallets Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/payments/initiate
 * بدء عملية دفع
 */
router.post('/initiate', async (req, res) => {
    try {
        const {
            patientId,
            amount,
            walletType,
            orderId,
            appointmentId,
            description
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!patientId || !amount || !walletType) {
            return res.status(400).json({
                success: false,
                error: 'البيانات المطلوبة ناقصة',
                code: 'MISSING_FIELDS'
            });
        }

        // التحقق من مبلغ الدفع
        const validation = validateAmount(amount, walletType);
        if (!validation.valid) {
            return res.status(400).json({
                success: false,
                error: validation.error,
                code: 'INVALID_AMOUNT'
            });
        }

        // التحقق من نوع المحفظة
        const wallet = supportedWallets[walletType];
        if (!wallet) {
            return res.status(400).json({
                success: false,
                error: 'نوع المحفظة غير مدعوم',
                code: 'UNSUPPORTED_WALLET'
            });
        }

        // إنشاء عملية الدفع
        const paymentId = uuidv4();
        const transactionId = generateTransactionId();

        const payment = {
            id: paymentId,
            transactionId,
            patientId,
            orderId: orderId || null,
            appointmentId: appointmentId || null,
            amount,
            currency: 'YER',
            walletType,
            status: 'pending',
            paymentMethod: 'wallet_transfer',
            transactionRef: null,
            description: description || 'دفع عبر صحتك',
            metadata: { walletName: wallet.name },
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        payments.set(paymentId, payment);

        res.status(201).json({
            success: true,
            message: 'تم إنشاء عملية الدفع',
            payment: formatPayment(payment),
            instructions: {
                walletName: wallet.name,
                amount: amount,
                steps: [
                    `1. افتح تطبيق ${wallet.name}`,
                    `2. اختر "إرسال أموال"`,
                    `3. أدخل رقم المستلم`,
                    `4. أدخل المبلغ: ${amount} ريال`,
                    `5. أدخل رقم المرجع: ${transactionId}`,
                    `6. أكد العملية`
                ]
            }
        });

    } catch (error) {
        console.error('[Payments] Initiate Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/payments/verify
 * التحقق من عملية الدفع
 */
router.post('/verify', async (req, res) => {
    try {
        const { transactionId, transactionRef } = req.body;

        if (!transactionId) {
            return res.status(400).json({
                success: false,
                error: 'معرف العملية مطلوب',
                code: 'TRANSACTION_ID_REQUIRED'
            });
        }

        // البحث عن العملية
        let payment = null;
        for (const p of payments.values()) {
            if (p.transactionId === transactionId) {
                payment = p;
                break;
            }
        }

        if (!payment) {
            return res.status(404).json({
                success: false,
                error: 'العملية غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        // في الإنتاج، يتم التحقق من المحفظة الإلكترونية
        // هنا نفترض أن الدفع تم بنجاح بعد إدخال المرجع
        if (transactionRef && payment.status === 'pending') {
            payment.transactionRef = transactionRef;
            payment.status = 'completed';
            payment.updatedAt = Date.now();
        }

        res.status(200).json({
            success: true,
            payment: formatPayment(payment),
            verified: payment.status === 'completed'
        });

    } catch (error) {
        console.error('[Payments] Verify Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/payments/:id
 * جلب بيانات عملية دفع
 */
router.get('/:id', (req, res) => {
    try {
        const payment = payments.get(req.params.id);

        if (!payment) {
            return res.status(404).json({
                success: false,
                error: 'العملية غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        res.status(200).json({
            success: true,
            payment: formatPayment(payment)
        });

    } catch (error) {
        console.error('[Payments] Get Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/payments/history
 * جلب سجل المدفوعات
 */
router.get('/history/:patientId', (req, res) => {
    try {
        const { patientId } = req.params;
        const { status, limit = 50 } = req.query;

        let filteredPayments = Array.from(payments.values())
            .filter(p => p.patientId === patientId);

        // تصفية حسب الحالة
        if (status) {
            filteredPayments = filteredPayments.filter(p => p.status === status);
        }

        // ترتيب
        filteredPayments.sort((a, b) => b.createdAt - a.createdAt);

        // تحديد العدد
        filteredPayments = filteredPayments.slice(0, parseInt(limit));

        res.status(200).json({
            success: true,
            payments: filteredPayments.map(formatPayment),
            total: filteredPayments.length
        });

    } catch (error) {
        console.error('[Payments] History Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/payments/confirm
 * تأكيد استلام الدفع (للطبيب/الصيدلية)
 */
router.post('/confirm', (req, res) => {
    try {
        const { paymentId, confirmedBy } = req.body;

        if (!paymentId) {
            return res.status(400).json({
                success: false,
                error: 'معرف العملية مطلوب',
                code: 'PAYMENT_ID_REQUIRED'
            });
        }

        const payment = payments.get(paymentId);
        if (!payment) {
            return res.status(404).json({
                success: false,
                error: 'العملية غير موجودة',
                code: 'NOT_FOUND'
            });
        }

        payment.status = 'completed';
        payment.metadata = {
            ...payment.metadata,
            confirmedBy,
            confirmedAt: Date.now()
        };
        payment.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم تأكيد استلام الدفع',
            payment: formatPayment(payment)
        });

    } catch (error) {
        console.error('[Payments] Confirm Error:', error);
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