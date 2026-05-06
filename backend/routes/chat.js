/**
 * ============================================
 * routes/chat.js - نظام الدردشة والمراسلة
 * ============================================
 *
 * نظام الدردشة الفورية مع WebSocket (Socket.io)
 * يحاكي الاتصال الحقيقي بالاستبدال في الإنتاج
 *
 * @author Sehatak Team
 * @version 2.0.0
 */

const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');

// ============================================
// تخزين المؤقت
// ============================================

// تخزين المحادثات
const conversations = new Map();

// تخزين الرسائل
const messages = new Map();

// تخزين المستخدمين المتصلين
const onlineUsers = new Map();

// ربط مع WebSocket (سيتم تعيينه من server.js)
let io = null;

/**
 * تعيين instance الـ Socket.io
 */
function setSocketIO(socketIO) {
    io = socketIO;
}

// ============================================
// دوال مساعدة
// ============================================

/**
 * إنشاء معرف محادثة فريد
 */
function createConversationId(userId1, userId2) {
    const sorted = [userId1, userId2].sort();
    return `conv_${sorted[0]}_${sorted[1]}`;
}

/**
 * تنسيق الرسالة
 */
function formatMessage(message) {
    return {
        id: message.id,
        conversationId: message.conversationId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        type: message.type || 'text', // text, image, file, voice
        status: message.status, // sent, delivered, read
        createdAt: message.createdAt,
        metadata: message.metadata || null
    };
}

/**
 * توليد رسالة معاودة
 */
function generateQuickReply(question) {
    const quickReplies = {
        'موعد': 'هل تريد حجز موعد جديد؟',
        'صيدلية': 'هل تحتاج إلى طلب أدوية من الصيدلية؟',
        'طوارئ': 'في حالة الطوارئ، اتصل بالرقم 191',
        '默认': 'شكراً لتواصلك معنا. كيف يمكننا مساعدتك؟'
    };

    for (const [key, value] of Object.entries(quickReplies)) {
        if (question.includes(key)) {
            return value;
        }
    }
    return quickReplies['默认'];
}

// ============================================
// Routes - REST API
// ============================================

/**
 * GET /api/chat/conversations
 * جلب قائمة المحادثات
 */
router.get('/conversations', (req, res) => {
    try {
        const userId = req.headers['x-user-id'];

        if (!userId) {
            return res.status(401).json({
                success: false,
                error: 'معرف المستخدم مطلوب',
                code: 'USER_ID_REQUIRED'
            });
        }

        // البحث عن محادثات المستخدم
        const userConversations = [];

        for (const [convId, conv] of conversations) {
            if (conv.participants.includes(userId)) {
                // البحث عن آخر رسالة
                const convMessages = messages.get(convId) || [];
                const lastMessage = convMessages[convMessages.length - 1] || null;

                // حساب عدد الرسائل غير المقروءة
                const unreadCount = convMessages.filter(m =>
                    m.receiverId === userId && m.status !== 'read'
                ).length;

                userConversations.push({
                    id: convId,
                    participants: conv.participants,
                    participantsInfo: conv.participantsInfo,
                    lastMessage: lastMessage ? formatMessage(lastMessage) : null,
                    unreadCount,
                    updatedAt: conv.updatedAt,
                    createdAt: conv.createdAt
                });
            }
        }

        // ترتيب حسب آخر تحديث
        userConversations.sort((a, b) => b.updatedAt - a.updatedAt);

        res.status(200).json({
            success: true,
            conversations: userConversations,
            total: userConversations.length
        });

    } catch (error) {
        console.error('[Chat Get Conversations] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/chat/conversations/:id
 * جلب محادثة معينة مع الرسائل
 */
router.get('/conversations/:id', (req, res) => {
    try {
        const userId = req.headers['x-user-id'];
        const { id } = req.params;
        const { limit = 50, before } = req.query;

        if (!userId) {
            return res.status(401).json({
                success: false,
                error: 'معرف المستخدم مطلوب',
                code: 'USER_ID_REQUIRED'
            });
        }

        // البحث عن المحادثة
        const conversation = conversations.get(id);

        if (!conversation) {
            return res.status(404).json({
                success: false,
                error: 'المحادثة غير موجودة',
                code: 'CONVERSATION_NOT_FOUND'
            });
        }

        // التحقق من مشاركة المستخدم
        if (!conversation.participants.includes(userId)) {
            return res.status(403).json({
                success: false,
                error: 'غير مصرح بالوصول لهذه المحادثة',
                code: 'UNAUTHORIZED'
            });
        }

        // جلب الرسائل
        let convMessages = messages.get(id) || [];

        // تصفية الرسائل القديمة إذا كان هناك before
        if (before) {
            const beforeTime = parseInt(before);
            convMessages = convMessages.filter(m => m.createdAt < beforeTime);
        }

        // تحديد عدد الرسائل
        convMessages = convMessages.slice(-parseInt(limit));

        res.status(200).json({
            success: true,
            conversation: {
                id: conversation.id,
                participants: conversation.participants,
                participantsInfo: conversation.participantsInfo,
                createdAt: conversation.createdAt
            },
            messages: convMessages.map(formatMessage),
            hasMore: convMessages.length >= parseInt(limit)
        });

    } catch (error) {
        console.error('[Chat Get Conversation] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/chat/conversations
 * إنشاء محادثة جديدة
 */
router.post('/conversations', (req, res) => {
    try {
        const { participantId, participantsInfo } = req.body;
        const senderId = req.headers['x-user-id'];

        if (!senderId || !participantId) {
            return res.status(400).json({
                success: false,
                error: 'معرف المرسل والمستقبل مطلوب',
                code: 'MISSING_IDS'
            });
        }

        // البحث عن محادثة موجودة
        const convId = createConversationId(senderId, participantId);
        let conversation = conversations.get(convId);

        if (conversation) {
            return res.status(200).json({
                success: true,
                conversation: conversation,
                isExisting: true
            });
        }

        // إنشاء محادثة جديدة
        conversation = {
            id: convId,
            participants: [senderId, participantId],
            participantsInfo: participantsInfo || {},
            createdAt: Date.now(),
            updatedAt: Date.now()
        };

        conversations.set(convId, conversation);
        messages.set(convId, []);

        res.status(201).json({
            success: true,
            conversation: conversation,
            isExisting: false
        });

    } catch (error) {
        console.error('[Chat Create Conversation] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * POST /api/chat/send
 * إرسال رسالة
 */
router.post('/send', (req, res) => {
    try {
        const senderId = req.headers['x-user-id'];
        const { conversationId, receiverId, content, type = 'text', metadata } = req.body;

        if (!senderId || (!conversationId && !receiverId)) {
            return res.status(400).json({
                success: false,
                error: 'المعرفات مطلوبة',
                code: 'MISSING_IDS'
            });
        }

        if (!content) {
            return res.status(400).json({
                success: false,
                error: 'محتوى الرسالة مطلوب',
                code: 'CONTENT_REQUIRED'
            });
        }

        // تحديد معرف المحادثة
        const convId = conversationId || createConversationId(senderId, receiverId);

        // التأكد من وجود المحادثة
        let conversation = conversations.get(convId);
        if (!conversation) {
            // إنشاء محادثة جديدة
            conversation = {
                id: convId,
                participants: [senderId, receiverId],
                participantsInfo: {},
                createdAt: Date.now(),
                updatedAt: Date.now()
            };
            conversations.set(convId, conversation);
            messages.set(convId, []);
        }

        // إنشاء الرسالة
        const messageId = uuidv4();
        const message = {
            id: messageId,
            conversationId: convId,
            senderId,
            receiverId: receiverId || conversation.participants.find(p => p !== senderId),
            content,
            type,
            status: 'sent',
            createdAt: Date.now(),
            metadata
        };

        // حفظ الرسالة
        const convMessages = messages.get(convId) || [];
        convMessages.push(message);
        messages.set(convId, convMessages);

        // تحديث وقت المحادثة
        conversation.updatedAt = Date.now();

        // إرسال عبر Socket.io
        if (io) {
            const receiverSocket = onlineUsers.get(message.receiverId);
            if (receiverSocket) {
                io.to(receiverSocket).emit('new_message', formatMessage(message));
            }

            // إرسال إشعار بالمحادثة
            io.to(receiverSocket).emit('conversation_update', {
                conversationId: convId,
                lastMessage: formatMessage(message),
                unreadCount: 1
            });
        }

        res.status(201).json({
            success: true,
            message: formatMessage(message)
        });

    } catch (error) {
        console.error('[Chat Send] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/chat/messages/:id/read
 * وضع علامة المقروء على الرسالة
 */
router.put('/messages/:id/read', (req, res) => {
    try {
        const userId = req.headers['x-user-id'];
        const { id } = req.params;

        // البحث عن الرسالة
        let foundMessage = null;
        let conversationId = null;

        for (const [convId, convMessages] of messages) {
            const message = convMessages.find(m => m.id === id);
            if (message) {
                foundMessage = message;
                conversationId = convId;
                break;
            }
        }

        if (!foundMessage) {
            return res.status(404).json({
                success: false,
                error: 'الرسالة غير موجودة',
                code: 'MESSAGE_NOT_FOUND'
            });
        }

        // تحديث حالة الرسالة
        foundMessage.status = 'read';

        // إرسال إشعار للمرسل
        if (io && foundMessage.senderId !== userId) {
            const senderSocket = onlineUsers.get(foundMessage.senderId);
            if (senderSocket) {
                io.to(senderSocket).emit('message_read', {
                    messageId: id,
                    readBy: userId,
                    readAt: Date.now()
                });
            }
        }

        res.status(200).json({
            success: true,
            message: formatMessage(foundMessage)
        });

    } catch (error) {
        console.error('[Chat Mark Read] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * PUT /api/chat/conversations/:id/read
 * وضع علامة المقروء على كل رسائل المحادثة
 */
router.put('/conversations/:id/read', (req, res) => {
    try {
        const userId = req.headers['x-user-id'];
        const { id } = req.params;

        const convMessages = messages.get(id) || [];
        let unreadCount = 0;

        convMessages.forEach(message => {
            if (message.receiverId === userId && message.status !== 'read') {
                message.status = 'read';
                unreadCount++;
            }
        });

        // إرسال إشعار للمرسل
        if (io && unreadCount > 0) {
            const conversation = conversations.get(id);
            if (conversation) {
                const otherParticipant = conversation.participants.find(p => p !== userId);
                const otherSocket = onlineUsers.get(otherParticipant);
                if (otherSocket) {
                    io.to(otherSocket).emit('messages_read', {
                        conversationId: id,
                        readBy: userId,
                        count: unreadCount
                    });
                }
            }
        }

        res.status(200).json({
            success: true,
            readCount: unreadCount
        });

    } catch (error) {
        console.error('[Chat Mark All Read] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * DELETE /api/chat/messages/:id
 * حذف رسالة
 */
router.delete('/messages/:id', (req, res) => {
    try {
        const userId = req.headers['x-user-id'];
        const { id } = req.params;

        for (const [convId, convMessages] of messages) {
            const messageIndex = convMessages.findIndex(m => m.id === id);
            if (messageIndex !== -1) {
                const message = convMessages[messageIndex];

                // التحقق من ملكية الرسالة
                if (message.senderId !== userId) {
                    return res.status(403).json({
                        success: false,
                        error: 'غير مصرح بحذف هذه الرسالة',
                        code: 'UNAUTHORIZED'
                    });
                }

                // حذف الرسالة
                convMessages.splice(messageIndex, 1);

                // إرسال إشعار بالحذف
                if (io) {
                    const receiverSocket = onlineUsers.get(message.receiverId);
                    if (receiverSocket) {
                        io.to(receiverSocket).emit('message_deleted', {
                            messageId: id,
                            conversationId: convId
                        });
                    }
                }

                return res.status(200).json({
                    success: true,
                    message: 'تم حذف الرسالة'
                });
            }
        }

        res.status(404).json({
            success: false,
            error: 'الرسالة غير موجودة',
            code: 'MESSAGE_NOT_FOUND'
        });

    } catch (error) {
        console.error('[Chat Delete] خطأ:', error);
        res.status(500).json({
            success: false,
            error: 'حدث خطأ',
            code: 'SERVER_ERROR'
        });
    }
});

/**
 * GET /api/chat/quick-replies
 * جلب ردود سريعة
 */
router.get('/quick-replies', (req, res) => {
    const quickReplies = [
        { id: '1', text: 'موعد', icon: '📅' },
        { id: '2', text: 'صيدلية', icon: '💊' },
        { id: '3', text: 'طوارئ', icon: '🚨' },
        { id: '4', text: 'تحاليل', icon: '🧪' },
        { id: '5', text: 'استشارة', icon: '💬' },
        { id: '6', text: 'متابعة', icon: '📋' }
    ];

    res.status(200).json({
        success: true,
        quickReplies
    });
});

/**
 * GET /api/chat/online-users
 * جلب المستخدمين المتصلين (للأطباء فقط)
 */
router.get('/online-users', (req, res) => {
    const userId = req.headers['x-user-id'];

    // إرجاع قائمة فارغة في هذا المثال
    // في الإنتاج الفعلي، سيتم التحقق من دور المستخدم

    res.status(200).json({
        success: true,
        onlineUsers: Array.from(onlineUsers.keys())
    });
});

// ============================================
// WebSocket Events
// ============================================

/**
 * إعداد مستمعي أحداث WebSocket
 */
function setupSocketHandlers(socket) {
    console.log(`[Socket.io] مستخدم متصل: ${socket.id}`);

    // مستخدم يتصل
    socket.on('user_online', (userId) => {
        onlineUsers.set(userId, socket.id);
        console.log(`[Socket.io] المستخدم ${userId} متصل`);

        // بث حالة المتصلين للأطباء
        if (io) {
            io.emit('online_users_update', Array.from(onlineUsers.keys()));
        }
    });

    // مستخدم يفصل
    socket.on('user_offline', (userId) => {
        onlineUsers.delete(userId);
        console.log(`[Socket.io] المستخدم ${userId} فصل`);

        if (io) {
            io.emit('online_users_update', Array.from(onlineUsers.keys()));
        }
    });

    // إرسال رسالة
    socket.on('send_message', (data) => {
        const { conversationId, receiverId, content, type, metadata } = data;

        // البحث عن المحادثة أو إنشاء واحدة جديدة
        let convId = conversationId || createConversationId(socket.userId, receiverId);
        let conversation = conversations.get(convId);

        if (!conversation) {
            conversation = {
                id: convId,
                participants: [socket.userId, receiverId],
                participantsInfo: {},
                createdAt: Date.now(),
                updatedAt: Date.now()
            };
            conversations.set(convId, conversation);
            messages.set(convId, []);
        }

        // إنشاء الرسالة
        const messageId = uuidv4();
        const message = {
            id: messageId,
            conversationId: convId,
            senderId: socket.userId,
            receiverId,
            content,
            type: type || 'text',
            status: 'sent',
            createdAt: Date.now(),
            metadata
        };

        // حفظ الرسالة
        const convMessages = messages.get(convId) || [];
        convMessages.push(message);
        messages.set(convId, convMessages);

        // تحديث المحادثة
        conversation.updatedAt = Date.now();

        // إرسال للمرreceiver
        const receiverSocket = onlineUsers.get(receiverId);
        if (receiverSocket) {
            io.to(receiverSocket).emit('new_message', formatMessage(message));
        }

        // إرسال تأكيد للمرسل
        socket.emit('message_sent', formatMessage(message));
    });

    // وضع علامة المقروء
    socket.on('mark_read', (data) => {
        const { messageId, conversationId } = data;

        const convMessages = messages.get(conversationId) || [];
        const message = convMessages.find(m => m.id === messageId);

        if (message && message.receiverId === socket.userId) {
            message.status = 'read';

            // إشعار للمرسل
            const senderSocket = onlineUsers.get(message.senderId);
            if (senderSocket) {
                io.to(senderSocket).emit('message_read', {
                    messageId,
                    readBy: socket.userId,
                    readAt: Date.now()
                });
            }
        }
    });

    // طلب بدء مكالمة
    socket.on('call_request', (data) => {
        const { receiverId, callType, conversationId } = data;

        const receiverSocket = onlineUsers.get(receiverId);
        if (receiverSocket) {
            io.to(receiverSocket).emit('incoming_call', {
                callerId: socket.userId,
                callType,
                conversationId,
                callerName: socket.userName || 'مستخدم',
                timestamp: Date.now()
            });
        }
    });

    // قبول/رفض المكالمة
    socket.on('call_response', (data) => {
        const { callerId, accepted, callId } = data;

        const callerSocket = onlineUsers.get(callerId);
        if (callerSocket) {
            io.to(callerSocket).emit('call_response', {
                accepted,
                calleeId: socket.userId,
                callId
            });
        }
    });

    // إنهاء المكالمة
    socket.on('call_end', (data) => {
        const { callId, participants } = data;

        participants.forEach(participantId => {
            const participantSocket = onlineUsers.get(participantId);
            if (participantSocket) {
                io.to(participantSocket).emit('call_ended', {
                    callId,
                    endedBy: socket.userId
                });
            }
        });
    });

    // كتابة...
    socket.on('typing_start', (data) => {
        const { conversationId } = data;

        const conversation = conversations.get(conversationId);
        if (conversation) {
            const otherParticipant = conversation.participants.find(p => p !== socket.userId);
            const otherSocket = onlineUsers.get(otherParticipant);
            if (otherSocket) {
                io.to(otherSocket).emit('user_typing', {
                    conversationId,
                    userId: socket.userId,
                    userName: socket.userName || 'مستخدم'
                });
            }
        }
    });

    socket.on('typing_stop', (data) => {
        const { conversationId } = data;

        const conversation = conversations.get(conversationId);
        if (conversation) {
            const otherParticipant = conversation.participants.find(p => p !== socket.userId);
            const otherSocket = onlineUsers.get(otherParticipant);
            if (otherSocket) {
                io.to(otherSocket).emit('user_stop_typing', {
                    conversationId,
                    userId: socket.userId
                });
            }
        }
    });

    // فصل
    socket.on('disconnect', () => {
        console.log(`[Socket.io] مستخدم فصل: ${socket.id}`);

        // البحث عن المستخدم وإزالته
        for (const [userId, socketId] of onlineUsers) {
            if (socketId === socket.id) {
                onlineUsers.delete(userId);
                console.log(`[Socket.io] المستخدم ${userId} فصل`);

                if (io) {
                    io.emit('online_users_update', Array.from(onlineUsers.keys()));
                }
                break;
            }
        }
    });
}

// ============================================
// تصدير
// ============================================

module.exports = router;
module.exports.setupSocketHandlers = setupSocketHandlers;
module.exports.setSocketIO = setSocketIO;