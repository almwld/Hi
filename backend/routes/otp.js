/**
 * ============================================
 * routes/otp.js - نظام التحقق بOTP
 * ============================================
 *
 * نظام إرسال والتحقق من رمز OTP
 * يدعم الإرسال عبر واتساب و SMS
 * التخزين المؤقت في الذاكرة (Map)
 *
 * @author Sehatak Team
 * @version 2.0.0
 */

const express = require('express');
const router = express.Router();

// ============================================
// التهيئة والمتغيرات
// ============================================

// تخزين مؤقت للأرقام OTP - في الإنتاج يُستبدل بـ Redis
const otpStore = new Map();

// إعدادات OTP
const OTP_CONFIG = {
    length: 6,                    // طول الرمز
    expiresIn: 5 * 60 * 1000,     // صلاحية الرمز: 5 دقائق
    maxAttempts: 3,               // أقصى محاولات تحقق
    cooldown: 60 * 1000,          // فترة انتظار بين المحاولات: دقيقة
    resendCooldown: 30 * 1000     // فترة انتظار إعادة الإرسال: 30 ثانية
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * توليد رمز OTP عشوائي
 */
function generateOTP() {
    const digits = '0123456789';
    let otp = '';
    for (let i = 0; i < OTP_CONFIG.length; i++) {
        otp += digits.charAt(Math.floor(Math.random() * digits.length));
    }
    return otp;
}

/**
 * تنظيف الأرقام المنتهية الصلاحية
 */
function cleanupExpiredOTPs() {
    const now = Date.now();
    for (const [phone, data] of otpStore.entries()) {
        if (now > data.expiresAt) {
            otpStore.delete(phone);
        }
    }
}

// تنظيف كل 5 دقائق
setInterval(cleanupExpiredOTPs, 5 * 60 * 1000);

/**
 * تنسيق رقم الهاتف اليمني
 */
function normalizePhoneNumber(phone) {
    // إزالة المسافات والشرطات
    let cleaned = phone.replace(/[\s\-]/g, '');

    // إضافة مفتاح الدولة إذا لم يكن موجوداً
    if (!cleaned.startsWith('967') && !cleaned.startsWith('+967')) {
        if (cleaned.startsWith('7') || cleaned.startsWith('7')) {
            cleaned = '967' + cleaned;
        }
    }

    return cleaned;
}

/**
 * محاكاة إرسال OTP عبر واتساب
 * في الإنتاج: استبدل بـ Twilio أو WhatsApp Business API
 */
async function sendViaWhatsApp(phone, otp) {
    console.log(`[WhatsApp] إرسال OTP ${otp} إلى ${phone}`);

    // في الإنتاج الفعلي:
    // const client = require('twilio')(accountSid, authToken);
    // await client.messages.create({
    //     from: 'whatsapp:+14155238886',
    //     body: `رمز التحقق الخاص بك في صحتك: ${otp}`,
    //     to: `whatsapp:+${phone}`
    // });

    return {
        success: true,
        channel: 'whatsapp',
        message: `تم إرسال رمز التحقق ${otp} عبر واتساب`
    };
}

/**
 * محاكاة إرسال OTP عبر SMS
 * في الإنتاج: استبدل بـ Twilio أو SMS Gateway يمني
 */
async function sendViaSMS(phone, otp) {
    console.log(`[SMS] إرسال OTP ${otp} إلى ${phone}`);

    // في الإنتاج الفعلي:
    // const client = require('twilio')(accountSid, authToken);
    // await client.messages.create({
    //     from: '+1XXXXXXXXXX',
    //     body: `رمز التحقق الخاص بك: ${otp}`,
    //     to: phone
    // });

    return {
        success: true,
        channel: 'sms',
        message: `تم إرسال رمز التحقق ${otp} عبر الرسائل النصية`
    };
}

// ============================================
// Routes
// ============================================

/**
 * POST /api/otp/send
 * إرسال رمز OTP إلى رقم الهاتف
 *
 * Body: { phone: string, channel: 'whatsapp' | 'sms' }
 */
router.post('/send', async (req, res) => {
    try {
        const { phone, channel = 'whatsapp' } = req.body;

        // التحقق من وجود رقم الهاتف
        if (!phone) {
            return res.status(400).json({
                success: false,
                error: 'رقم الهاتف مطلوب',
                code: 'PHONE_REQUIRED'
            });
        }

        // تنسيق رقم الهاتف
        const normalizedPhone = normalizePhoneNumber(phone);

        // التحقق من صحة الرقم
        if (normalizedPhone.length < 10 || normalizedPhone.length > 13) {
            return res.status(400).json({
                success: false,
                error: 'رقم الهاتف غير صالح',
                code: 'INVALID_PHONE'
            });
        }

        // التحقق من فترة الانتظار
        const existingOTP = otpStore.get(normalizedPhone);
        if (existingOTP) {
            const now = Date.now();

            // التحقق من فترة إعادة الإرسال
            if (now < existingOTP.lastSendTime + OTP_CONFIG.resendCooldown) {
                const remainingTime = Math.ceil(
                    (existingOTP.lastSendTime + OTP_CONFIG.resendCooldown - now) / 1000
                );
                return res.status(429).json({
                    success: false,
                    error: `يرجى الانتظار ${remainingTime} ثانية قبل إعادة الإرسال`,
                    code: 'COOLDOWN_ACTIVE',
                    retryAfter: remainingTime
                });
            }
        }

        // توليد رمز OTP جديد
        const otp = generateOTP();
        const expiresAt = Date.now() + OTP_CONFIG.expiresIn;

        // تخزين البيانات
        otpStore.set(normalizedPhone, {
            otp: otp,
            expiresAt: expiresAt,
            attempts: 0,
            createdAt: Date.now(),
            lastSendTime: Date.now(),
            verified: false
        });

        // إرسال OTP حسب القناة المطلوبة
        let result;
        if (channel === 'sms') {
            result = await sendViaSMS(normalizedPhone, otp);
        } else {
            result = await sendViaWhatsApp(normalizedPhone, otp);
        }

        // إرسال الاستجابة
        res.status(200).json({
            success: true,
            message: result.message,
            channel: result.channel,
            expiresIn: OTP_CONFIG.expiresIn / 1000,
            debug: process.env.NODE_ENV === 'development' ? { otp } : undefined
        });

    } catch (error) {
        console.error('[OTP Send] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ أثناء إرسال رمز التحقق',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/otp/verify
 * التحقق من رمز OTP
 *
 * Body: { phone: string, otp: string }
 */
router.post('/verify', async (req, res) => {
    try {
        const { phone, otp } = req.body;

        // التحقق من البيانات المطلوبة
        if (!phone || !otp) {
            return res.status(400).json({
                success: false,
                error: 'رقم الهاتف ورمز التحقق مطلوبان',
                code: 'MISSING_FIELDS'
            });
        }

        // تنسيق رقم الهاتف
        const normalizedPhone = normalizePhoneNumber(phone);

        // البحث عن OTP المحفوظ
        const otpData = otpStore.get(normalizedPhone);

        // التحقق من وجود OTP
        if (!otpData) {
            return res.status(400).json({
                success: false,
                error: 'لم يتم العثور على رمز تحقق. يرجى طلب رمز جديد',
                code: 'OTP_NOT_FOUND'
            });
        }

        // التحقق من صلاحية الرمز
        if (Date.now() > otpData.expiresAt) {
            otpStore.delete(normalizedPhone);
            return res.status(400).json({
                success: false,
                error: 'انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد',
                code: 'OTP_EXPIRED'
            });
        }

        // التحقق من عدد المحاولات
        if (otpData.attempts >= OTP_CONFIG.maxAttempts) {
            otpStore.delete(normalizedPhone);
            return res.status(400).json({
                success: false,
                error: 'تم تجاوز عدد المحاولات المسموحة. يرجى طلب رمز جديد',
                code: 'MAX_ATTEMPTS_EXCEEDED'
            });
        }

        // زيادة عدد المحاولات
        otpData.attempts++;

        // التحقق من الرمز
        if (otpData.otp !== otp) {
            const remainingAttempts = OTP_CONFIG.maxAttempts - otpData.attempts;
            return res.status(400).json({
                success: false,
                error: `رمز التحقق غير صحيح. محاولات متبقية: ${remainingAttempts}`,
                code: 'INVALID_OTP',
                remainingAttempts: remainingAttempts
            });
        }

        // نجاح التحقق
        otpData.verified = true;

        res.status(200).json({
            success: true,
            message: 'تم التحقق بنجاح',
            verified: true,
            phone: normalizedPhone,
            token: generateTempToken(normalizedPhone) // رمز مؤقت للاستخدام الواحد
        });

        // حذف OTP بعد التحقق (اختياري - للاحتفاظ بـ verified: true)
        // otpStore.delete(normalizedPhone);

    } catch (error) {
        console.error('[OTP Verify] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ أثناء التحقق من رمز التحقق',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/otp/resend
 * إعادة إرسال رمز OTP
 */
router.post('/resend', async (req, res) => {
    // إعادة استخدام route الإرسال
    req.body.channel = req.body.channel || 'whatsapp';
    return router.handle(req, res);
});

/**
 * GET /api/otp/status
 * التحقق من حالة OTP لرقم هاتف
 */
router.get('/status/:phone', (req, res) => {
    const normalizedPhone = normalizePhoneNumber(req.params.phone);
    const otpData = otpStore.get(normalizedPhone);

    if (!otpData) {
        return res.status(200).json({
            exists: false,
            message: 'لا يوجد OTP لهذا الرقم'
        });
    }

    const now = Date.now();
    const isExpired = now > otpData.expiresAt;
    const remainingAttempts = OTP_CONFIG.maxAttempts - otpData.attempts;

    res.status(200).json({
        exists: true,
        verified: otpData.verified,
        expired: isExpired,
        attemptsUsed: otpData.attempts,
        remainingAttempts: remainingAttempts,
        expiresAt: otpData.expiresAt,
        remainingSeconds: isExpired ? 0 : Math.ceil((otpData.expiresAt - now) / 1000)
    });
});

/**
 * DELETE /api/otp/clear
 * حذف OTP لرقم هاتف (للتسجيل الجديد)
 */
router.delete('/clear/:phone', (req, res) => {
    const normalizedPhone = normalizePhoneNumber(req.params.phone);
    const deleted = otpStore.delete(normalizedPhone);

    res.status(200).json({
        success: true,
        deleted: deleted,
        message: deleted ? 'تم حذف OTP بنجاح' : 'لم يكن هناك OTP لهذا الرقم'
    });
});

// ============================================
// دوال إضافية
// ============================================

/**
 * توليد رمز مؤقت للتحقق
 */
function generateTempToken(phone) {
    const jwt = require('jsonwebtoken');
    const secret = process.env.JWT_SECRET || 'sehatak_jwt_secret_2024_secure_key';

    return jwt.sign(
        {
            phone: phone,
            type: 'otp_verification',
            timestamp: Date.now()
        },
        secret,
        { expiresIn: '5m' }
    );
}

/**
 * Middleware للتحقق من OTP تم التحقق منه
 */
function requireVerifiedOTP(req, res, next) {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
            success: false,
            error: 'رمز التحقق مطلوب',
            code: 'TOKEN_REQUIRED'
        });
    }

    try {
        const jwt = require('jsonwebtoken');
        const secret = process.env.JWT_SECRET || 'sehatak_jwt_secret_2024_secure_key';
        const token = authHeader.split(' ')[1];

        const decoded = jwt.verify(token, secret);

        if (decoded.type !== 'otp_verification') {
            return res.status(401).json({
                success: false,
                error: 'نوع الرمز غير صحيح',
                code: 'INVALID_TOKEN_TYPE'
            });
        }

        req.phone = decoded.phone;
        next();
    } catch (error) {
        return res.status(401).json({
            success: false,
            error: 'الرمز غير صالح أو منتهي الصلاحية',
            code: 'INVALID_TOKEN'
        });
    }
}

// ============================================
// تصدير
// ============================================

module.exports = router;
module.exports.requireVerifiedOTP = requireVerifiedOTP;