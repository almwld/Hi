/**
 * ============================================
 * routes/appointments.js - نظام الحجز والمواعيد
 * ============================================
 *
 * نظام حجز المواعيد مع الأطباء
 * يشمل: حجز، إلغاء، تعديل، تذكيرات
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

// المواعيد
const appointments = new Map();

// أوقات عمل الأطباء (تجريبي)
const doctorSchedules = {
    'doctor-1': {
        workingDays: [1, 2, 3, 4, 5], // الأحد - الخميس
        workingHours: { start: 9, end: 17 },
        slotDuration: 30, // دقائق لكل موعد
        breakTime: { start: 13, end: 14 } // استراحة الغداء
    },
    'doctor-2': {
        workingDays: [0, 2, 4, 6], // السبت، الإثنين، الأربعاء، الجمعة
        workingHours: { start: 10, end: 18 },
        slotDuration: 30,
        breakTime: null
    },
    'doctor-3': {
        workingDays: [1, 2, 3, 4, 5],
        workingHours: { start: 8, end: 16 },
        slotDuration: 20,
        breakTime: { start: 12, end: 13 }
    }
};

// بيانات الأطباء
const doctors = {
    'doctor-1': {
        id: 'doctor-1',
        name: 'د. أحمد محمد العواضي',
        specialty: 'طب القلب والأوعية الدموية',
        city: 'صنعاء',
        rating: 4.8,
        consultationPrice: 5000,
        avatar: null,
        experience: 15
    },
    'doctor-2': {
        id: 'doctor-2',
        name: 'د. فاطمة علي新媒体',
        specialty: 'طب الأطفال',
        city: 'عدن',
        rating: 4.9,
        consultationPrice: 4000,
        avatar: null,
        experience: 12
    },
    'doctor-3': {
        id: 'doctor-3',
        name: 'د. خالد عبدالله الحميدي',
        specialty: 'الطب العام',
        city: 'تعز',
        rating: 4.7,
        consultationPrice: 3000,
        avatar: null,
        experience: 8
    }
};

// ============================================
// دوال مساعدة
// ============================================

/**
 * توليد أوقات متاحة للطبيب في يوم معين
 */
function generateAvailableSlots(doctorId, date) {
    const schedule = doctorSchedules[doctorId];
    if (!schedule) return [];

    const dayOfWeek = new Date(date).getDay();
    if (!schedule.workingDays.includes(dayOfWeek)) {
        return []; // يوم راحة
    }

    const slots = [];
    const { start, end } = schedule.workingHours;
    const { slotDuration, breakTime } = schedule;

    for (let hour = start; hour < end; hour++) {
        for (let minute = 0; minute < 60; minute += slotDuration) {
            // التحقق من وقت الاستراحة
            if (breakTime && hour === breakTime.start && minute === 0) {
                continue;
            }

            const time = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
            const dateTime = new Date(`${date}T${time}:00`);

            // التحقق من أن الوقت في المستقبل
            if (dateTime <= new Date()) {
                continue;
            }

            // التحقق من عدم وجود موعد في هذا الوقت
            const isBooked = Array.from(appointments.values()).some(apt =>
                apt.doctorId === doctorId &&
                new Date(apt.dateTime).getTime() === dateTime.getTime() &&
                apt.status !== 'cancelled'
            );

            slots.push({
                time,
                dateTime: dateTime.toISOString(),
                available: !isBooked
            });
        }
    }

    return slots;
}

/**
 * التحقق من صحة تاريخ ووقت الموعد
 */
function validateAppointmentDateTime(doctorId, dateTime) {
    const schedule = doctorSchedules[doctorId];
    if (!schedule) {
        return { valid: false, error: 'الطبيب غير موجود' };
    }

    const date = new Date(dateTime);
    const dayOfWeek = date.getDay();

    // التحقق من يوم العمل
    if (!schedule.workingDays.includes(dayOfWeek)) {
        return { valid: false, error: 'هذا اليوم ليس من أيام عمل الطبيب' };
    }

    // التحقق من ساعة العمل
    const hour = date.getHours();
    const minute = date.getMinutes();
    const { start, end, breakTime } = schedule.workingHours;

    if (hour < start || hour >= end) {
        return { valid: false, error: 'خارج ساعات العمل' };
    }

    // التحقق من وقت الاستراحة
    if (breakTime && hour === breakTime.start && minute === 0) {
        return { valid: false, error: 'وقت الاستراحة' };
    }

    // التحقق من عدم وجود موعد في نفس الوقت
    const isBooked = Array.from(appointments.values()).some(apt =>
        apt.doctorId === doctorId &&
        new Date(apt.dateTime).getTime() === date.getTime() &&
        apt.status !== 'cancelled'
    );

    if (isBooked) {
        return { valid: false, error: 'هذا الوقت محجوز مسبقاً' };
    }

    return { valid: true };
}

/**
 * تنسيق الموعد
 */
function formatAppointment(appointment) {
    return {
        id: appointment.id,
        patientId: appointment.patientId,
        doctorId: appointment.doctorId,
        doctor: doctors[appointment.doctorId] || null,
        dateTime: appointment.dateTime,
        type: appointment.type, // consultation, follow_up, checkup
        status: appointment.status, // pending, confirmed, completed, cancelled
        reason: appointment.reason,
        notes: appointment.notes,
        price: appointment.price,
        isPaid: appointment.isPaid,
        createdAt: appointment.createdAt,
        updatedAt: appointment.updatedAt
    };
}

// ============================================
// Routes
// ============================================

/**
 * GET /api/appointments
 * جلب مواعيد المريض
 */
router.get('/', (req, res) => {
    try {
        const { patientId, status, fromDate, toDate } = req.query;

        if (!patientId) {
            return res.status(400).json({
                success: false,
                error: 'معرف المريض مطلوب',
                code: 'PATIENT_ID_REQUIRED'
            });
        }

        let filteredAppointments = Array.from(appointments.values())
            .filter(apt => apt.patientId === patientId);

        // تصفية حسب الحالة
        if (status) {
            filteredAppointments = filteredAppointments.filter(
                apt => apt.status === status
            );
        }

        // تصفية حسب التاريخ
        if (fromDate) {
            const from = new Date(fromDate);
            filteredAppointments = filteredAppointments.filter(
                apt => new Date(apt.dateTime) >= from
            );
        }

        if (toDate) {
            const to = new Date(toDate);
            filteredAppointments = filteredAppointments.filter(
                apt => new Date(apt.dateTime) <= to
            );
        }

        // ترتيب حسب التاريخ
        filteredAppointments.sort((a, b) =>
            new Date(b.dateTime) - new Date(a.dateTime)
        );

        res.status(200).json({
            success: true,
            appointments: filteredAppointments.map(formatAppointment),
            total: filteredAppointments.length
        });

    } catch (error) {
        console.error('[Appointments] Get Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/appointments/:id
 * جلب موعد معين
 */
router.get('/:id', (req, res) => {
    try {
        const appointment = appointments.get(req.params.id);

        if (!appointment) {
            return res.status(404).json({
                success: false,
                error: 'الموعد غير موجود',
                code: 'NOT_FOUND'
            });
        }

        res.status(200).json({
            success: true,
            appointment: formatAppointment(appointment)
        });

    } catch (error) {
        console.error('[Appointments] Get By ID Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/appointments
 * إنشاء موعد جديد
 */
router.post('/', async (req, res) => {
    try {
        const {
            patientId,
            doctorId,
            dateTime,
            type = 'consultation',
            reason,
            notes
        } = req.body;

        // التحقق من البيانات المطلوبة
        if (!patientId || !doctorId || !dateTime) {
            return res.status(400).json({
                success: false,
                error: 'البيانات المطلوبة ناقصة',
                code: 'MISSING_FIELDS'
            });
        }

        // التحقق من الطبيب
        const doctor = doctors[doctorId];
        if (!doctor) {
            return res.status(404).json({
                success: false,
                error: 'الطبيب غير موجود',
                code: 'DOCTOR_NOT_FOUND'
            });
        }

        // التحقق من صحة الوقت
        const validation = validateAppointmentDateTime(doctorId, dateTime);
        if (!validation.valid) {
            return res.status(400).json({
                success: false,
                error: validation.error,
                code: 'INVALID_DATETIME'
            });
        }

        // إنشاء الموعد
        const appointmentId = uuidv4();
        const appointment = {
            id: appointmentId,
            patientId,
            doctorId,
            dateTime: new Date(dateTime).toISOString(),
            type,
            status: 'pending',
            reason: reason || null,
            notes: notes || null,
            price: doctor.consultationPrice,
            isPaid: false,
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        appointments.set(appointmentId, appointment);

        res.status(201).json({
            success: true,
            message: 'تم حجز الموعد بنجاح',
            appointment: formatAppointment(appointment)
        });

    } catch (error) {
        console.error('[Appointments] Create Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/appointments/:id
 * تحديث موعد
 */
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { dateTime, type, reason, notes, status } = req.body;

        const appointment = appointments.get(id);
        if (!appointment) {
            return res.status(404).json({
                success: false,
                error: 'الموعد غير موجود',
                code: 'NOT_FOUND'
            });
        }

        // تحديث البيانات
        if (dateTime) {
            const validation = validateAppointmentDateTime(appointment.doctorId, dateTime);
            if (!validation.valid) {
                return res.status(400).json({
                    success: false,
                    error: validation.error,
                    code: 'INVALID_DATETIME'
                });
            }
            appointment.dateTime = new Date(dateTime).toISOString();
        }

        if (type) appointment.type = type;
        if (reason !== undefined) appointment.reason = reason;
        if (notes !== undefined) appointment.notes = notes;
        if (status) appointment.status = status;
        appointment.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم تحديث الموعد',
            appointment: formatAppointment(appointment)
        });

    } catch (error) {
        console.error('[Appointments] Update Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * DELETE /api/appointments/:id
 * إلغاء موعد
 */
router.delete('/:id', (req, res) => {
    try {
        const appointment = appointments.get(req.params.id);

        if (!appointment) {
            return res.status(404).json({
                success: false,
                error: 'الموعد غير موجود',
                code: 'NOT_FOUND'
            });
        }

        appointment.status = 'cancelled';
        appointment.updatedAt = Date.now();

        res.status(200).json({
            success: true,
            message: 'تم إلغاء الموعد',
            appointment: formatAppointment(appointment)
        });

    } catch (error) {
        console.error('[Appointments] Cancel Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/appointments/doctor/:doctorId
 * جلب مواعيد طبيب معين
 */
router.get('/doctor/:doctorId', (req, res) => {
    try {
        const { doctorId } = req.params;
        const { date, fromDate, toDate } = req.query;

        let filteredAppointments = Array.from(appointments.values())
            .filter(apt => apt.doctorId === doctorId && apt.status !== 'cancelled');

        // تصفية حسب التاريخ
        if (date) {
            const targetDate = new Date(date).toDateString();
            filteredAppointments = filteredAppointments.filter(apt =>
                new Date(apt.dateTime).toDateString() === targetDate
            );
        }

        if (fromDate) {
            filteredAppointments = filteredAppointments.filter(apt =>
                new Date(apt.dateTime) >= new Date(fromDate)
            );
        }

        if (toDate) {
            filteredAppointments = filteredAppointments.filter(apt =>
                new Date(apt.dateTime) <= new Date(toDate)
            );
        }

        // ترتيب
        filteredAppointments.sort((a, b) =>
            new Date(a.dateTime) - new Date(b.dateTime)
        );

        res.status(200).json({
            success: true,
            appointments: filteredAppointments.map(formatAppointment),
            total: filteredAppointments.length
        });

    } catch (error) {
        console.error('[Appointments] Get Doctor Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/appointments/available-slots
 * جلب الأوقات المتاحة للطبيب
 */
router.get('/available-slots/:doctorId', (req, res) => {
    try {
        const { doctorId } = req.params;
        const { date, days = 7 } = req.query;

        const doctor = doctors[doctorId];
        if (!doctor) {
            return res.status(404).json({
                success: false,
                error: 'الطبيب غير موجود',
                code: 'DOCTOR_NOT_FOUND'
            });
        }

        const slots = [];
        const startDate = date ? new Date(date) : new Date();
        const daysCount = parseInt(days);

        for (let i = 0; i < daysCount; i++) {
            const currentDate = new Date(startDate);
            currentDate.setDate(startDate.getDate() + i);

            const dateStr = currentDate.toISOString().split('T')[0];
            const daySlots = generateAvailableSlots(doctorId, dateStr);

            if (daySlots.length > 0) {
                slots.push({
                    date: dateStr,
                    dayName: currentDate.toLocaleDateString('ar-SA', { weekday: 'long' }),
                    availableSlots: daySlots
                });
            }
        }

        res.status(200).json({
            success: true,
            doctor: {
                id: doctor.id,
                name: doctor.name,
                specialty: doctor.specialty
            },
            slots,
            totalDays: slots.length
        });

    } catch (error) {
        console.error('[Appointments] Get Slots Error:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/appointments/doctors
 * جلب قائمة الأطباء
 */
router.get('/doctors/list', (req, res) => {
    try {
        const { city, specialty, search } = req.query;

        let filteredDoctors = Object.values(doctors);

        if (city) {
            filteredDoctors = filteredDoctors.filter(d =>
                d.city.toLowerCase().includes(city.toLowerCase())
            );
        }

        if (specialty) {
            filteredDoctors = filteredDoctors.filter(d =>
                d.specialty.toLowerCase().includes(specialty.toLowerCase())
            );
        }

        if (search) {
            const searchLower = search.toLowerCase();
            filteredDoctors = filteredDoctors.filter(d =>
                d.name.toLowerCase().includes(searchLower) ||
                d.specialty.toLowerCase().includes(searchLower)
            );
        }

        res.status(200).json({
            success: true,
            doctors: filteredDoctors,
            total: filteredDoctors.length
        });

    } catch (error) {
        console.error('[Appointments] Get Doctors Error:', error);
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