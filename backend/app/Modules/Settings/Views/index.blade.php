
@extends('layouts.admin')

@section('title', ' Settings')

@section('content')



<div class="settingsPage">

    {{-- LEFT SETTINGS SIDEBAR --}}
    <div class="settingsSidebar">

        <div class="sidebarHeader">

            {{-- BACK BUTTON --}}
             <a href="{{ route('admin.dashboard') }}"
             class="dashboardBackButton">

                 ← Back To Dashboard

                </a>

                <div class="settingsHeading">

                <h2>Settings</h2>

                <p>Enterprise control panel</p>

             </div>

        </div>

        <div class="sidebarMenu">

            <button onclick="switchTab('account')"
                    id="btn-account"
                    class="settingsButton activeButton">

                <span>👤 Account</span>

                <span>›</span>

            </button>

            <button onclick="switchTab('security')"
                    id="btn-security"
                    class="settingsButton">

                <span>🔐 Security</span>

                <span>›</span>

            </button>

            <button onclick="switchTab('notifications')"
                    id="btn-notifications"
                    class="settingsButton">

                <span>🔔 Notifications</span>

                <span>›</span>

            </button>

            <button onclick="switchTab('staffroles')"
                    id="btn-staffroles"
                    class="settingsButton">

                <span>👨‍💼 Staff Roles</span>

                <span>›</span>

            </button>

        </div>

    </div>

    {{-- RIGHT CONTENT --}}
    <div class="settingsContent">

        {{-- ACCOUNT TAB --}}
        <div id="account-tab" class="tabContent">

                        <div class="contentHeader">

                <div class="headerLeft">

                    

                    <div>

                        <h1>
                            Account Settings
                        </h1>

                        <p>
                            Manage profile information
                        </p>

                    </div>

                </div>

            </div>

            <div class="contentGrid">

                <div class="cardBox">

                    <h3>
                        Edit Profile
                    </h3>

                    <div class="inputGroup">

                        <label>
                            Full Name
                        </label>

                        <input type="text"
                               placeholder="Enter full name">

                    </div>

                    <div class="inputGroup">

                        <label>
                            Email Address
                        </label>

                        <input type="email"
                               placeholder="Enter email">

                    </div>

                    <div class="inputGroup">

                        <label>
                            Phone Number
                        </label>

                        <input type="text"
                               placeholder="Enter phone">

                    </div>

                </div>

                <div class="cardBox">

                    <h3>
                        Change Password
                    </h3>

                    <div class="inputGroup">

                        <label>
                            Current Password
                        </label>

                        <input type="password">

                    </div>

                    <div class="inputGroup">

                        <label>
                            New Password
                        </label>

                        <input type="password">

                    </div>

                </div>

            </div>

        </div>

        {{-- SECURITY TAB --}}
        <div id="security-tab"
             class="tabContent hidden">

            <div class="contentHeader">

                <div>

                    <h1>
                        Security
                    </h1>

                    <p>
                        Manage account security
                    </p>

                </div>

            </div>

            <div class="cardBox">

                <div class="permissionBox">

                    <div>

                        <h4>
                            Two Factor Authentication
                        </h4>

                        <p>
                            Enable extra security
                        </p>

                    </div>

                    <input type="checkbox">

                </div>

            </div>

        </div>

        {{-- NOTIFICATIONS TAB --}}
        <div id="notifications-tab"
             class="tabContent hidden">

            <div class="contentHeader">

                <div>

                    <h1>
                        Notifications
                    </h1>

                    <p>
                        Manage notification settings
                    </p>

                </div>

            </div>

            <div class="cardBox">

                <div class="permissionBox">

                    <div>

                        <h4>
                            Email Notifications
                        </h4>

                        <p>
                            Receive email updates
                        </p>

                    </div>

                    <input type="checkbox" checked>

                </div>

            </div>

        </div>

        {{-- STAFF ROLES TAB --}}
        <div id="staffroles-tab"
             class="tabContent hidden">

            <form method="POST"
                  action="{{ route('settings.save') }}"
                  id="settingsForm">

                @csrf

                <input type="hidden"
                       name="staff_roles"
                       id="staff_roles_input">

                <div class="contentHeader">

                    <div>

                        <h1>
                            Staff Roles
                        </h1>

                        <p>
                            Manage dashboard access permissions
                        </p>

                    </div>

                    <button type="button"
                            onclick="addRole()"
                            class="saveBtn">

                        + Add Role

                    </button>

                </div>

                <div id="rolesContainer">

                    @forelse($staffRoles as $role)
                        <div class="roleCard">

                            <div class="roleHeader">

                                <div>

                                    <input type="text"
                                           value="{{ $role['name'] }}"
                                           class="roleInput">

                                    <p>
                                        {{ $role['description'] ?? 'Custom permissions' }}
                                    </p>

                                </div>

                                <button type="button"
                                        onclick="deleteRole(this)"
                                        class="deleteBtn">

                                    Delete

                                </button>

                            </div>

                            <div class="permissionGrid">

                                @foreach($permissions as $permissionKey => $permissionMeta)
                                    <label class="permissionBox"
                                           data-permission="{{ $permissionKey }}">

                                        <div>

                                            <h4>
                                                {{ $permissionMeta['label'] }}
                                            </h4>

                                            <p>
                                                {{ $permissionMeta['description'] }}
                                            </p>

                                        </div>

                                        <input type="checkbox"
                                               data-permission="{{ $permissionKey }}"
                                               {{ !empty($role['permissions'][$permissionKey]) ? 'checked' : '' }}>

                                    </label>
                                @endforeach

                            </div>

                        </div>
                    @empty
                        <div class="roleCard">

                            <div class="roleHeader">

                                <div>

                                    <input type="text"
                                           value="Administrator"
                                           class="roleInput">

                                    <p>
                                        Full system access
                                    </p>

                                </div>

                                <button type="button"
                                        onclick="deleteRole(this)"
                                        class="deleteBtn">

                                    Delete

                                </button>

                            </div>

                            <div class="permissionGrid">

                                @foreach($permissions as $permissionKey => $permissionMeta)
                                    <label class="permissionBox"
                                           data-permission="{{ $permissionKey }}">

                                        <div>

                                            <h4>
                                                {{ $permissionMeta['label'] }}
                                            </h4>

                                            <p>
                                                {{ $permissionMeta['description'] }}
                                            </p>

                                        </div>

                                        <input type="checkbox"
                                               data-permission="{{ $permissionKey }}"
                                               checked>

                                    </label>
                                @endforeach

                            </div>

                        </div>
                    @endforelse

                </div>

                <div class="formActions" style="margin-top: 24px;">
                    <button type="submit"
                            class="saveBtn">
                        Save Staff Roles
                    </button>
                </div>

            </form>

        </div>

    </div>

</div>

<style>

.settingsPage{
    display:flex;
    height:calc(100vh - 70px);
    background:#071220;
    overflow:hidden;
}

.settingsSidebar{
    width:280px;
    background:#0b1725;
    border-right:1px solid #1e293b;
    padding:24px;
}

.sidebarHeader h2{
    color:white;
    font-size:28px;
    font-weight:700;
}

.sidebarHeader p{
    color:#94a3b8;
    margin-top:6px;
}

.sidebarMenu{
    margin-top:40px;
    display:flex;
    flex-direction:column;
    gap:12px;
}

.settingsButton{
    width:100%;
    height:60px;
    border:none;
    background:transparent;
    border-radius:16px;
    padding:0 18px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    color:#cbd5e1;
    transition:0.3s;
    cursor:pointer;
}

.settingsButton:hover{
    background:#132234;
}

.activeButton{
    background:linear-gradient(90deg,#143654,#0f2741);
    color:white;
    border-right:3px solid #06b6d4;
}

.settingsContent{
    flex:1;
    overflow-y:auto;
    padding:40px;
}

.contentHeader{
    display:flex;
    align-items:center;
    justify-content:space-between;
    margin-bottom:30px;
}

.contentHeader h1{
    color:white;
    font-size:34px;
    font-weight:700;
}

.contentHeader p{
    color:#94a3b8;
    margin-top:6px;
}

.contentGrid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:24px;
}

.cardBox{
    background:#0b1725;
    border:1px solid #1e293b;
    border-radius:24px;
    padding:28px;
}

.cardBox h3{
    color:white;
    font-size:22px;
    margin-bottom:24px;
}

.inputGroup{
    margin-bottom:20px;
}

.inputGroup label{
    display:block;
    color:#cbd5e1;
    margin-bottom:10px;
}

.inputGroup input{
    width:100%;
    height:54px;
    background:#071220;
    border:1px solid #24384f;
    border-radius:14px;
    padding:0 16px;
    color:white;
}

.roleCard{
    background:#0b1725;
    border:1px solid #1e293b;
    border-radius:24px;
    padding:24px;
    margin-bottom:20px;
}

.roleHeader{
    display:flex;
    align-items:center;
    justify-content:space-between;
    margin-bottom:24px;
}

.roleHeader p{
    color:#94a3b8;
    margin-top:5px;
}

.roleInput{
    background:transparent;
    border:none;
    color:white;
    font-size:24px;
    font-weight:700;
    outline:none;
}

.permissionGrid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
}

.permissionBox{
    background:#071220;
    border:1px solid #24384f;
    border-radius:18px;
    padding:18px;
    display:flex;
    align-items:center;
    justify-content:space-between;
}

.permissionBox h4{
    color:white;
    font-size:15px;
}

.permissionBox p{
    color:#94a3b8;
    font-size:13px;
    margin-top:5px;
}

.permissionBox input{
    width:18px;
    height:18px;
    accent-color:#06b6d4;
}

.saveBtn{
    background:linear-gradient(90deg,#06b6d4,#22d3ee);
    border:none;
    color:white;
    height:50px;
    padding:0 22px;
    border-radius:14px;
    font-weight:600;
    cursor:pointer;
}

.deleteBtn{
    background:rgba(239,68,68,0.15);
    color:#f87171;
    border:none;
    padding:10px 16px;
    border-radius:12px;
    cursor:pointer;
}

.hidden{
    display:none;
}

.headerLeft{
    display:flex;
    align-items:center;
    gap:18px;
}
.dashboardBackButton{
    width:100%;
    height:54px;
    background:#132234;
    border:1px solid #24384f;
    border-radius:16px;
    color:white;
    text-decoration:none;
    display:flex;
    align-items:center;
    justify-content:center;
    font-weight:600;
    margin-bottom:24px;
    transition:0.3s;
}

.dashboardBackButton:hover{
    background:#06b6d4;
    border-color:#06b6d4;
}

.settingsHeading h2{
    color:white;
    font-size:28px;
    font-weight:700;
}

.settingsHeading p{
    color:#94a3b8;
    margin-top:6px;
}

</style>

<script>

function switchTab(tabName){

    document.querySelectorAll('.tabContent').forEach(tab => {
        tab.classList.add('hidden');
    });

    const activeTab = document.getElementById(tabName + '-tab');

    if(activeTab){
        activeTab.classList.remove('hidden');
    }

    document.querySelectorAll('.settingsButton').forEach(btn => {
        btn.classList.remove('activeButton');
    });

    document.getElementById('btn-' + tabName)
            .classList.add('activeButton');
}

function getStaffRolesData(){
    const roles = [];

    document.querySelectorAll('#rolesContainer .roleCard').forEach(card => {
        const nameInput = card.querySelector('.roleInput');
        const descriptionText = card.querySelector('.roleHeader p');

        if (!nameInput) {
            return;
        }

        const permissions = {};

        card.querySelectorAll('.permissionGrid input[type="checkbox"]').forEach(input => {
            const permission = input.dataset.permission;
            if (permission) {
                permissions[permission] = input.checked;
            }
        });

        roles.push({
            name: nameInput.value.trim() || 'New Role',
            description: descriptionText ? descriptionText.textContent.trim() : 'Custom permissions',
            permissions,
        });
    });

    return roles;
}

function addRole(){
    const permissions = @json($permissions);

    let permissionHTML = '';

    Object.entries(permissions).forEach(([key, permission]) => {
        permissionHTML += `
            <label class="permissionBox" data-permission="${key}">

                <div>

                    <h4>
                        ${permission.label}
                    </h4>

                    <p>
                        ${permission.description}
                    </p>

                </div>

                <input type="checkbox"
                       data-permission="${key}">

            </label>
        `;
    });

    const roleHTML = `

        <div class="roleCard">

            <div class="roleHeader">

                <div>

                    <input type="text"
                           value="New Role"
                           class="roleInput">

                    <p>
                        Custom permissions
                    </p>

                </div>

                <button type="button"
                        onclick="deleteRole(this)"
                        class="deleteBtn">

                    Delete

                </button>

            </div>

            <div class="permissionGrid">
                ${permissionHTML}
            </div>

        </div>

    `;

    document.getElementById('rolesContainer')
            .insertAdjacentHTML('beforeend', roleHTML);
}

function deleteRole(button){

    button.closest('.roleCard').remove();
}

const settingsForm = document.getElementById('settingsForm');
if (settingsForm) {
    settingsForm.addEventListener('submit', function () {
        const rolesInput = document.getElementById('staff_roles_input');
        if (rolesInput) {
            rolesInput.value = JSON.stringify(getStaffRolesData());
        }
    });
}

</script>

@endsection