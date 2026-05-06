/**
 * ============================================
 * tests/api.test.js - اختبارات التكامل للـ API
 * ============================================
 *
 * اختبارات شاملة لجميع نقاط نهاية API
 * الباك إند: OTP, Auth, Chat
 *
 * @author Sehatak Team
 * @version 2.0.0
 */

// استخدام Jest للاختبارات
const http = require('http');

// إعدادات الاختبار
const BASE_URL = 'http://localhost:3000';
const TEST_PHONE = '967771234567';

// ============================================
// دوال مساعدة
// ============================================

/**
 * طلب HTTP بسيط
 */
function httpRequest(options, body = null) {
    return new Promise((resolve, reject) => {
        const req = http.request(options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                try {
                    resolve({
                        status: res.statusCode,
                        body: JSON.parse(data)
                    });
                } catch (e) {
                    resolve({
                        status: res.statusCode,
                        body: data
                    });
                }
            });
        });
        req.on('error', reject);
        if (body) req.write(JSON.stringify(body));
        req.end();
    });
}

/**
 * إنشاء طلب POST
 */
function post(path, body, headers = {}) {
    return httpRequest({
        hostname: 'localhost',
        port: 3000,
        path: path,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            ...headers
        }
    }, body);
}

/**
 * إنشاء طلب GET
 */
function get(path, headers = {}) {
    return httpRequest({
        hostname: 'localhost',
        port: 3000,
        path: path,
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            ...headers
        }
    });
}

/**
 * إنشاء طلب PUT
 */
function put(path, body, headers = {}) {
    return httpRequest({
        hostname: 'localhost',
        port: 3000,
        path: path,
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            ...headers
        }
    }, body);
}

/**
 * إنشاء طلب DELETE
 */
function del(path, headers = {}) {
    return httpRequest({
        hostname: 'localhost',
        port: 3000,
        path: path,
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json',
            ...headers
        }
    });
}

// ============================================
// الاختبارات
// ============================================

describe('Sehatak API Integration Tests', () => {

    // ============================================
    // Health Check
    // ============================================

    describe('Health Check', () => {
        test('GET /health - يجب أن يرجع حالة صحية', async () => {
            const response = await get('/health');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.status).toBe('healthy');
            expect(response.body.version).toBeDefined();
        });
    });

    // ============================================
    // API Root
    // ============================================

    describe('API Root', () => {
        test('GET /api - يجب أن يرجع معلومات API', async () => {
            const response = await get('/api');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.version).toBe('2.0.0');
            expect(response.body.endpoints).toBeDefined();
        });
    });

    // ============================================
    // OTP Routes
    // ============================================

    describe('OTP Routes', () => {
        test('POST /api/otp/send - إرسال OTP بنجاح', async () => {
            const response = await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.channel).toBe('whatsapp');
            expect(response.body.expiresIn).toBeDefined();
            // في التطوير، يتم إرجاع OTP للتحقق
            if (process.env.NODE_ENV === 'development') {
                expect(response.body.debug).toBeDefined();
            }
        });

        test('POST /api/otp/send - خطأ بدون رقم الهاتف', async () => {
            const response = await post('/api/otp/send', {});

            expect(response.status).toBe(400);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('PHONE_REQUIRED');
        });

        test('POST /api/otp/send - رقم هاتف غير صالح', async () => {
            const response = await post('/api/otp/send', {
                phone: '123', // رقم قصير جداً
                channel: 'whatsapp'
            });

            expect(response.status).toBe(400);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('INVALID_PHONE');
        });

        test('POST /api/otp/send - منع الإرسال المتكرر (cooldown)', async () => {
            // إرسال أول
            await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            // محاولة إرسال ثانٍ مباشرة
            const response = await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            expect(response.status).toBe(429);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('COOLDOWN_ACTIVE');
            expect(response.body.retryAfter).toBeDefined();
        });

        test('POST /api/otp/verify - التحقق بنجاح', async () => {
            // إرسال OTP أولاً
            const sendResponse = await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            // استخدام OTP الحقيقي (في التطوير)
            const debugOTP = sendResponse.body.debug?.otp || '123456';

            // التحقق
            const verifyResponse = await post('/api/otp/verify', {
                phone: TEST_PHONE,
                otp: debugOTP
            });

            expect(verifyResponse.status).toBe(200);
            expect(verifyResponse.body.success).toBe(true);
            expect(verifyResponse.body.verified).toBe(true);
            expect(verifyResponse.body.token).toBeDefined();
        });

        test('POST /api/otp/verify - رمز OTP خاطئ', async () => {
            const response = await post('/api/otp/verify', {
                phone: TEST_PHONE,
                otp: '000000' // رمز خاطئ
            });

            expect(response.status).toBe(400);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('INVALID_OTP');
            expect(response.body.remainingAttempts).toBeDefined();
        });

        test('POST /api/otp/verify - بدون رقم الهاتف', async () => {
            const response = await post('/api/otp/verify', {
                otp: '123456'
            });

            expect(response.status).toBe(400);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('MISSING_FIELDS');
        });

        test('GET /api/otp/status/:phone - جلب حالة OTP', async () => {
            // إرسال OTP أولاً
            await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            const response = await get(`/api/otp/status/${encodeURIComponent(TEST_PHONE)}`);

            expect(response.status).toBe(200);
            expect(response.body.exists).toBe(true);
            expect(response.body.verified).toBe(false);
        });

        test('DELETE /api/otp/clear/:phone - حذف OTP', async () => {
            const response = await del(`/api/otp/clear/${encodeURIComponent(TEST_PHONE)}`);

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.deleted).toBe(true);
        });
    });

    // ============================================
    // Auth Routes
    // ============================================

    describe('Auth Routes', () => {
        let accessToken;

        test('POST /api/auth/register - تسجيل مستخدم جديد', async () => {
            const response = await post('/api/auth/register', {
                phone: TEST_PHONE,
                name: 'مستخدم تجريبي',
                email: 'test@example.com'
            });

            expect(response.status).toBe(201);
            expect(response.body.success).toBe(true);
            expect(response.body.user).toBeDefined();
            expect(response.body.user.phone).toBeDefined();
            expect(response.body.accessToken).toBeDefined();
            expect(response.body.refreshToken).toBeDefined();

            accessToken = response.body.accessToken;
        });

        test('POST /api/auth/login/send-otp - إرسال OTP لتسجيل الدخول', async () => {
            const response = await post('/api/auth/login/send-otp', {
                phone: TEST_PHONE
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.userExists).toBe(true);
        });

        test('POST /api/auth/login/verify - تسجيل الدخول بنجاح', async () => {
            // إرسال OTP
            await post('/api/otp/send', {
                phone: TEST_PHONE,
                channel: 'whatsapp'
            });

            // في التطوير، نستخدم أي رمز صالح
            const response = await post('/api/auth/login/verify', {
                phone: TEST_PHONE,
                otp: '123456' // رمز تجريبي
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.user).toBeDefined();
            expect(response.body.accessToken).toBeDefined();

            accessToken = response.body.accessToken;
        });

        test('GET /api/auth/profile - جلب الملف الشخصي (بدون توكن)', async () => {
            const response = await get('/api/auth/profile');

            expect(response.status).toBe(401);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('TOKEN_REQUIRED');
        });

        test('GET /api/auth/profile - جلب الملف الشخصي (مع توكن)', async () => {
            const response = await get('/api/auth/profile', {
                'Authorization': `Bearer ${accessToken}`
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.user).toBeDefined();
            expect(response.body.user.phone).toBeDefined();
        });

        test('PUT /api/auth/profile - تحديث الملف الشخصي', async () => {
            const response = await put('/api/auth/profile', {
                name: 'اسم محدث',
                city: 'صنعاء'
            }, {
                'Authorization': `Bearer ${accessToken}`
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.user.name).toBe('اسم محدث');
            expect(response.body.user.city).toBe('صنعاء');
        });

        test('GET /api/auth/doctors - جلب قائمة الأطباء', async () => {
            const response = await get('/api/auth/doctors');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.doctors).toBeDefined();
            expect(Array.isArray(response.body.doctors)).toBe(true);
        });

        test('GET /api/auth/doctors - تصفية حسب المدينة', async () => {
            const response = await get('/api/auth/doctors?city=صنعاء');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.doctors).toBeDefined();
        });

        test('GET /api/auth/doctors/:id - جلب طبيب معين', async () => {
            const response = await get('/api/auth/doctors/doctor-1');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.doctor).toBeDefined();
            expect(response.body.doctor.name).toBeDefined();
        });

        test('POST /api/auth/logout - تسجيل الخروج', async () => {
            const response = await post('/api/auth/logout', {
                refreshToken: 'test-refresh-token'
            }, {
                'Authorization': `Bearer ${accessToken}`
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
        });
    });

    // ============================================
    // Chat Routes
    // ============================================

    describe('Chat Routes', () => {
        const userId1 = 'test-user-1';
        const userId2 = 'test-user-2';

        test('GET /api/chat/conversations - جلب المحادثات (بدون user-id)', async () => {
            const response = await get('/api/chat/conversations');

            expect(response.status).toBe(401);
            expect(response.body.success).toBe(false);
            expect(response.body.code).toBe('USER_ID_REQUIRED');
        });

        test('GET /api/chat/conversations - جلب المحادثات (مع user-id)', async () => {
            const response = await get('/api/chat/conversations', {
                'x-user-id': userId1
            });

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.conversations).toBeDefined();
            expect(Array.isArray(response.body.conversations)).toBe(true);
        });

        test('POST /api/chat/conversations - إنشاء محادثة جديدة', async () => {
            const response = await post('/api/chat/conversations', {
                participantId: userId2,
                participantsInfo: {
                    [userId1]: { name: 'مستخدم 1' },
                    [userId2]: { name: 'مستخدم 2' }
                }
            }, {
                'x-user-id': userId1
            });

            expect(response.status).toBe(201);
            expect(response.body.success).toBe(true);
            expect(response.body.conversation).toBeDefined();
            expect(response.body.conversation.participants).toContain(userId1);
            expect(response.body.conversation.participants).toContain(userId2);
        });

        test('POST /api/chat/send - إرسال رسالة', async () => {
            const response = await post('/api/chat/send', {
                receiverId: userId2,
                content: 'مرحباً، هذه رسالة تجريبية',
                type: 'text'
            }, {
                'x-user-id': userId1
            });

            expect(response.status).toBe(201);
            expect(response.body.success).toBe(true);
            expect(response.body.message).toBeDefined();
            expect(response.body.message.content).toBe('مرحباً، هذه رسالة تجريبية');
        });

        test('GET /api/chat/quick-replies - جلب الردود السريعة', async () => {
            const response = await get('/api/chat/quick-replies');

            expect(response.status).toBe(200);
            expect(response.body.success).toBe(true);
            expect(response.body.quickReplies).toBeDefined();
            expect(Array.isArray(response.body.quickReplies)).toBe(true);
            expect(response.body.quickReplies.length).toBeGreaterThan(0);
        });
    });

});

// ============================================
// تشغيل الاختبارات
// ============================================

console.log(`
╔══════════════════════════════════════════════╗
║  sehatak Backend Integration Tests            ║
╠══════════════════════════════════════════════╣
║  Base URL: ${BASE_URL}
║  Test Phone: ${TEST_PHONE}
╚══════════════════════════════════════════════╝
`);