<%-- 
    Document   : notifications 
    Created on : 6 May 2025, 5:45:40 pm 
    Author     : nurin 
--%> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- 🔔 Notification Bell + Dropdown Menu -->
<div class="dropdown nav-item">
    <button class="btn text-white dropdown-toggle" type="button"
            id="notificationDropdown"
            data-bs-toggle="dropdown"
            aria-expanded="false">
        <i class='bx bx-bell bx-sm'></i>
        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
              id="notificationCount" style="display: none;">0</span>
    </button>

    <ul class="dropdown-menu dropdown-menu-end shadow"
        aria-labelledby="notificationDropdown"
        id="notificationList">
        <li class="d-flex justify-content-between align-items-center px-3 py-2 border-bottom notification-header" style="display: none;">
            <span class="text-muted small">Notifications</span>
            <button class="btn btn-sm btn-link text-decoration-none" id="markAllReadBtn">Mark all as read</button>
        </li>
    </ul>
</div>

<style>
    #notificationCount {
        font-size: 0.7rem;
        padding: 2px 6px;
    }

    #notificationList {
        width: 350px;
        max-height: 500px;
        overflow-y: auto;
        background-color: white;
        z-index: 1052;
        border-radius: 0.5rem;
    }

    .notification-item {
        display: flex;
        flex-direction: column;
        justify-content: center;
        width: 100%;
        cursor: pointer;
        border-radius: 0.4rem;
        background-color: #e8f0fe;
        padding: 10px 14px;
        margin-bottom: 4px;
        border: 1px solid #ccc;
        font-size: 14px;
        color: #000;
        word-break: break-word;
    }

    .notification-item:hover {
        background-color: #dbeafe;
    }

    .notif-text {
        color: #000;
        font-weight: bold;
        margin-bottom: 4px;
    }

    .text-muted {
        color: #333 !important;
    }

    .dropdown-menu li {
        padding-left: 8px;
        padding-right: 8px;
    }
</style>

<script>
    function loadNotifications() {
        $.ajax({
            url: '<%= request.getContextPath() %>/FetchNotificationsServlet',
            method: 'GET',
            dataType: 'json',
            success: function (data) {
                const list = document.getElementById('notificationList');
                // Remove everything except the first <li> (header)
                while (list.children.length > 1) list.removeChild(list.lastChild);

                let unreadCount = 0;
                const notifications = Array.isArray(data) ? data : [];

                notifications.forEach(notif => {
                    if (!notif.isRead) unreadCount++;
                });

                document.querySelector('.notification-header').style.display = unreadCount > 0 ? 'flex' : 'none';

                if (unreadCount === 0) {
                    document.getElementById('notificationCount').style.display = 'none';
                    const empty = document.createElement('li');
                    empty.className = "text-center text-muted py-3";
                    empty.textContent = "No New Messages";
                    list.appendChild(empty);
                    return;
                }

                // Render each unread notification
                notifications.forEach(notif => {
                    if (!notif.isRead) {
                        const message = notif.message || 'No message';
                        const createdAt = notif.createdAt || '';

                        const li = document.createElement('li');
                        li.className = 'px-2 py-2';

                        const container = document.createElement('div');
                        container.className = 'notification-item unread';
                        container.dataset.id = notif.notificationID;

                        const textDiv = document.createElement('div');
                        textDiv.className = 'notif-text';
                        textDiv.textContent = message;

                        const small = document.createElement('small');
                        small.className = 'text-muted';
                        small.textContent = createdAt;

                        container.appendChild(textDiv);
                        container.appendChild(small);
                        li.appendChild(container);
                        list.appendChild(li);
                    }
                });

                document.getElementById('notificationCount').textContent = unreadCount;
                document.getElementById('notificationCount').style.display = 'inline-block';

                // Click behavior
                document.querySelectorAll('.notification-item').forEach(el => {
                    el.addEventListener('click', function () {
                        const id = this.dataset.id;
                        const message = this.querySelector('.notif-text').textContent;

                        if (id) markAsRead(id, this);

                        if (message.includes("project (ID:")) {
                            const projectID = message.match(/\(ID:\s*(\d+)\)/)?.[1];
                            if (projectID) window.location.href = '<%= request.getContextPath()%>/viewProject.jsp?projectID=' + projectID;
                        } else if (message.includes("task (ID:")) {
                            const taskID = message.match(/\(ID:\s*(\d+)\)/)?.[1];
                            if (taskID) window.location.href = '<%= request.getContextPath()%>/viewTasks.jsp?taskID=' + taskID;
                        }
                    });
                });
            },
            error: function () {
                const list = document.getElementById('notificationList');
                while (list.children.length > 1) list.removeChild(list.lastChild);
                const error = document.createElement('li');
                error.className = "text-center text-danger py-3";
                error.textContent = "Failed to load notifications";
                list.appendChild(error);
                document.getElementById('notificationCount').style.display = 'none';
            }
        });
    }

    function markAsRead(notificationID, el) {
        $.post('<%= request.getContextPath() %>/MarkNotificationReadServlet', { id: notificationID }, function () {
            el.closest('li').remove();
            updateNotificationCount();
        });
    }

    function markAllAsRead() {
        $.post('<%= request.getContextPath() %>/MarkNotificationReadServlet', { action: 'all' }, function () {
            document.querySelectorAll('.notification-item.unread').forEach(el => el.closest('li').remove());
            updateNotificationCount();
        });
    }

    function updateNotificationCount() {
        const unreadCount = document.querySelectorAll('.notification-item.unread').length;
        document.getElementById('notificationCount').textContent = unreadCount;
        document.getElementById('notificationCount').style.display = unreadCount > 0 ? 'inline-block' : 'none';
        document.querySelector('.notification-header').style.display = unreadCount > 0 ? 'flex' : 'none';

        if (unreadCount === 0) {
            const list = document.getElementById('notificationList');
            const empty = document.createElement('li');
            empty.className = "text-center text-muted py-3";
            empty.textContent = "No New Messages";
            list.appendChild(empty);
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        setTimeout(loadNotifications, 1000);
        setInterval(loadNotifications, 60000);
        document.getElementById('markAllReadBtn').addEventListener('click', function (e) {
            e.preventDefault();
            markAllAsRead();
        });
    });
</script>
