# Backend Refactoring Plan - Trackyond Mock API

## Separating Logic and Clean Endpoints

### Executive Summary

This document outlines a comprehensive plan to refactor the backend API to separate business logic from route handlers, creating clean endpoints that invoke dedicated functions for data retrieval and transformation. The refactoring will maintain backward compatibility while improving code maintainability and testability.

---

## Current State Analysis

### ✅ Already Following Best Practices

1. **Dashboard Endpoints**
   - `GET /api/v1/employee/dashboard` → Calls `get_employee_dashboard_data()` ✓
   - `GET /api/v1/admin/dashboard` → Calls `get_admin_dashboard_data()` ✓
2. **Attendance Endpoints**
   - `POST /attendance/start` → Calls `start_employee_attendance()` ✓
   - `POST /attendance/end` → Calls `end_employee_attendance()` ✓
3. **Jobs Endpoints**
   - `GET /jobs` (admin) → Calls `get_admin_jobs()` ✓
   - `GET /jobs` (employee) → Calls `get_employee_assigned_jobs()` ✓

4. **Profile Endpoints**
   - `GET /profiles` → Calls `get_employee_profiles_data()` ✓
   - `GET /profiles/me` → Calls `get_employee_profile_data()` ✓

5. **Auth Endpoints**
   - Calls dedicated auth service functions ✓

### ⚠️ Areas for Improvement

1. **Data Aggregation Functions**
   - Dashboard fetches data independently - could benefit from grouped data fetchers
   - Multiple queries could be batched/optimized

2. **Serialization Consistency**
   - Serializers scattered in multiple places
   - Some serialization logic embedded in services

3. **Data Transformation Layer**
   - Some transformation happens in services, some in routes
   - Need consistent pattern for DTO/response building

---

## Proposed Architecture

```
API Route Handler (Thin)
        ↓
Use Cases / Data Access Layer (New)
        ↓
Service Functions (Business Logic)
        ↓
Database Models
```

### New Folder Structure

```
trackyond-mock-api/
├── services/
│   ├── __init__.py
│   ├── auth_service.py          (EXISTING - Auth logic)
│   ├── jobs_service.py          (EXISTING - Job operations)
│   ├── attendance_service.py    (EXISTING - Attendance operations)
│   ├── profile_service.py       (EXISTING - Profile operations)
│   ├── company_service.py       (EXISTING - Company operations)
│   ├── members_service.py       (EXISTING - Members operations)
│   ├── dashboard_service.py     (EXISTING - Dashboard data)
│   ├── file_service.py          (EXISTING - File operations)
│   ├── token_service.py         (EXISTING - Token operations)
│   ├── serializers.py           (EXISTING - Serialization utilities)
│   └── data_access.py           (NEW - Data fetching & aggregation)
│
├── use_cases/                   (NEW - Feature-specific logic)
│   ├── __init__.py
│   ├── admin_use_cases.py       (Admin operations aggregator)
│   ├── employee_use_cases.py    (Employee operations aggregator)
│   └── auth_use_cases.py        (Auth operations aggregator)
│
└── api/v1/
    ├── admin/
    │   ├── auth.py              (REFACTORED - Thin)
    │   ├── jobs.py              (REFACTORED - Thin)
    │   ├── attendance.py        (REFACTORED - Thin)
    │   ├── dashboard.py         (REFACTORED - Thin)
    │   ├── company.py           (REFACTORED - Thin)
    │   ├── members.py           (REFACTORED - Thin)
    │   └── profiles.py          (REFACTORED - Thin)
    │
    └── employee/
        ├── auth.py              (REFACTORED - Thin)
        ├── jobs.py              (REFACTORED - Thin)
        ├── attendance.py        (REFACTORED - Thin)
        ├── dashboard.py         (REFACTORED - Thin)
        └── profiles.py          (REFACTORED - Thin)
```

---

## Refactoring Plan by Feature

### Phase 1: Setup Data Access Layer (CURRENT)

#### 1.1 Create `services/data_access.py`

**Purpose**: Centralized data fetching functions for all features

```python
# services/data_access.py

# ADMIN DATA FETCHING
def admin_fetch_dashboard_metrics(db, admin_uid):
    """Fetch only metrics for admin dashboard"""

def admin_fetch_team_attendance_today(db, admin_uid):
    """Fetch only today's team attendance"""

def admin_fetch_recent_jobs(db, admin_uid, limit=10):
    """Fetch only recent jobs"""

def admin_fetch_job_statistics(db, admin_uid):
    """Fetch only job counts by status"""

def admin_fetch_all_jobs_with_filters(db, admin_uid, filters):
    """Fetch jobs with complete filtering"""

def admin_fetch_attendance_logs(db, admin_uid, filters):
    """Fetch attendance logs with filters"""

def admin_fetch_members(db, admin_uid):
    """Fetch all company members"""

def admin_fetch_company(db, admin_uid):
    """Fetch admin's company data"""

# EMPLOYEE DATA FETCHING
def employee_fetch_assigned_jobs(db, account_uid, filters):
    """Fetch jobs assigned to employee"""

def employee_fetch_attendance_status(db, account_uid):
    """Fetch current attendance status"""

def employee_fetch_profiles(db, user_uid):
    """Fetch all profiles for user"""

def employee_fetch_profile_active(db, user_uid):
    """Fetch active profile for user"""

def employee_fetch_dashboard_metrics(db, user_uid, account_uid):
    """Fetch dashboard metrics for employee"""

# COMMON DATA FETCHING
def fetch_user_by_phone(db, phone):
    """Fetch user by phone number"""

def fetch_member(db, account_uid):
    """Fetch member by account_uid"""

def fetch_company(db, company_id):
    """Fetch company by ID"""
```

---

### Phase 2: Create Use Cases Layer

#### 2.1 Create `use_cases/admin_use_cases.py`

**Purpose**: Orchestrate multiple data fetches for admin operations

```python
# use_cases/admin_use_cases.py

def build_admin_dashboard(db, admin_uid):
    """
    Aggregate all dashboard data by calling individual fetch functions

    Returns:
    {
        "teamMembersStatus": [...],
        "jobCounts": {...},
        "jobChart": [...],
        "recentJobs": [...]
    }
    """

def build_admin_jobs_list(db, admin_uid, filters):
    """
    Build complete jobs list with worker details
    """

def build_admin_attendance_report(db, admin_uid, filters):
    """
    Build attendance logs with calculated metrics
    """

def build_admin_team_status(db, admin_uid, status_filter):
    """
    Build team status with today's attendance
    """
```

#### 2.2 Create `use_cases/employee_use_cases.py`

**Purpose**: Orchestrate data fetches for employee operations

```python
# use_cases/employee_use_cases.py

def build_employee_dashboard(db, user_uid, account_uid):
    """
    Aggregate employee dashboard data
    """

def build_employee_profile_summary(db, user_uid):
    """
    Build employee profile with company info
    """

def build_employee_jobs_list(db, account_uid, filters):
    """
    Build employee's assigned jobs list
    """
```

#### 2.3 Create `use_cases/auth_use_cases.py`

**Purpose**: Orchestrate authentication operations

```python
# use_cases/auth_use_cases.py

def process_otp_send(db, phone, device_id, role, is_resend=False):
    """
    Handle OTP sending with validation
    """

def process_otp_verify(db, phone, otp_id, otp, device_id, metadata, role):
    """
    Handle OTP verification and return tokens
    """

def process_token_refresh(db, authorization, x_refresh_token, device_id):
    """
    Handle token refresh
    """
```

---

### Phase 3: Refactor Endpoints

#### 3.1 Admin Routes Refactoring

**BEFORE: admin/dashboard.py**

```python
@router.get("", response_model=GenericResponse)
async def get_dashboard(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_dashboard_data(db, admin.uid)
    if error:
        return GenericResponse(success=False, message=error)

    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data=data
    )
```

**AFTER: admin/dashboard.py**

```python
from use_cases.admin_use_cases import build_admin_dashboard
from core.exceptions import AppException

@router.get("", response_model=GenericResponse)
async def get_dashboard(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    """
    Thin endpoint: Only coordinates the use case
    """
    try:
        data = build_admin_dashboard(db, admin.uid)
        return GenericResponse(
            success=True,
            message="Dashboard data fetched successfully",
            data=data
        )
    except AppException as e:
        return GenericResponse(success=False, message=e.message)
```

#### 3.2 Admin Jobs Refactoring

**BEFORE: admin/jobs.py (Lines 14-45)**

```python
@router.get("", response_model=GenericResponse)
async def get_jobs(
    # ... 13 parameters ...
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    data, error = get_admin_jobs(
        db=db,
        admin_uid=admin.uid,
        # ... pass all parameters ...
    )
    if error:
        return GenericResponse(success=False, message=error)
    return GenericResponse(...)
```

**AFTER: admin/jobs.py**

```python
from use_cases.admin_use_cases import build_admin_jobs_list

@router.get("", response_model=GenericResponse)
async def get_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("assignedAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[list[str]] = Query(None, alias="statuses[]"),
    worker_ids: Optional[list[str]] = Query(None, alias="workerIds[]"),
    search: Optional[str] = Query(None),
    search_by: str = Query("all", alias="searchBy"),
    from_date: Optional[str] = Query(None, alias="fromDate"),
    to_date: Optional[str] = Query(None, alias="toDate"),
    logical_operator: str = Query("and", alias="logicalOperator"),
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    """
    Thin endpoint: Builds filter dict and calls use case
    """
    filters = {
        "limit": limit,
        "offset": offset,
        "order_by": order_by,
        "order": order,
        "status": status,
        "worker_ids": worker_ids,
        "search": search,
        "search_by": search_by,
        "from_date": from_date,
        "to_date": to_date,
        "logical_operator": logical_operator,
    }

    try:
        data = build_admin_jobs_list(db, admin.uid, filters)
        return GenericResponse(
            success=True,
            message="Jobs fetched successfully",
            data=data
        )
    except AppException as e:
        return GenericResponse(success=False, message=e.message)
```

#### 3.3 Employee Jobs Refactoring

**BEFORE: employee/jobs.py**

```python
@router.get("", response_model=GenericResponse)
async def get_assigned_jobs(
    # ... 10 parameters ...
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    data, error = get_employee_assigned_jobs(
        db=db,
        primary_account_uid=user.primary_account_uid,
        # ... pass parameters ...
    )
    if error:
        return GenericResponse(success=False, message=error)
    return GenericResponse(...)
```

**AFTER: employee/jobs.py**

```python
from use_cases.employee_use_cases import build_employee_jobs_list

@router.get("", response_model=GenericResponse)
async def get_assigned_jobs(
    limit: int = Query(20, ge=1),
    offset: int = Query(0, ge=0),
    order_by: str = Query("createdAt", alias="orderBy"),
    order: str = Query("desc"),
    status: Optional[list[str]] = Query(None, alias="statuses"),
    search: Optional[str] = Query(None),
    search_by: str = Query("all", alias="searchBy"),
    from_date: Optional[str] = Query(None, alias="fromDate"),
    to_date: Optional[str] = Query(None, alias="toDate"),
    db: Session = Depends(get_db),
    user: models.User = Depends(get_current_user)
):
    """
    Thin endpoint: Builds filter dict and calls use case
    """
    filters = {
        "limit": limit,
        "offset": offset,
        "order_by": order_by,
        "order": order,
        "status": status,
        "search": search,
        "search_by": search_by,
        "from_date": from_date,
        "to_date": to_date,
    }

    try:
        data = build_employee_jobs_list(db, user.primary_account_uid, filters)
        return GenericResponse(
            success=True,
            message="Assigned jobs fetched successfully",
            data=data
        )
    except AppException as e:
        return GenericResponse(success=False, message=e.message)
```

---

## Implementation Steps (WITHOUT Breaking)

### Step 1: Create New Files (Non-Breaking)

✅ Create `services/data_access.py` (new file, no changes to existing code)
✅ Create `use_cases/admin_use_cases.py` (new file)
✅ Create `use_cases/employee_use_cases.py` (new file)
✅ Create `use_cases/auth_use_cases.py` (new file)
✅ Create `use_cases/__init__.py`

**Risk Level**: ⬇️ ZERO - Only adding new code

### Step 2: Migrate Services One by One

For each endpoint group:

1. Create the use case function
2. Test it independently
3. Refactor the endpoint to use it
4. Run integration tests
5. Move to next endpoint

**Order of Migration**:

1. ✅ Dashboard endpoints (already clean)
2. Jobs endpoints (admin + employee)
3. Attendance endpoints
4. Profile endpoints
5. Auth endpoints
6. Company/Members endpoints

**Risk Level**: 🟡 LOW - Each change is isolated and can be reverted

### Step 3: Update Serializers (If Needed)

- Consolidate serialization logic
- Add helper functions for common transformations

**Risk Level**: 🟡 LOW - Serializers are utility functions

### Step 4: Add Tests

- Write unit tests for data access layer
- Write integration tests for use cases
- Verify endpoints work as before

**Risk Level**: ⬇️ ZERO - Tests don't change functionality

---

## Detailed Implementation: Dashboard Example

### Current Code Flow

```
Route Handler → Service Function (get_admin_dashboard_data) → DB
```

### New Code Flow

```
Route Handler (thin)
    ↓
Use Case (build_admin_dashboard)
    ↓
Data Access Functions
    - admin_fetch_dashboard_metrics(db)
    - admin_fetch_team_attendance_today(db)
    - admin_fetch_recent_jobs(db)
    - admin_fetch_job_statistics(db)
    ↓
Service Functions (existing)
    ↓
DB Models
```

### Implementation for Dashboard

#### Step 1: Create data_access functions

```python
# services/data_access.py

def admin_fetch_team_status_today(db, admin_uid):
    """Fetch today's team attendance status"""
    admin_member = db.query(models.Member).filter(
        models.Member.user_uid == admin_uid
    ).first()

    if not admin_member:
        raise AppException("Admin profile not found")

    members = db.query(models.Member).filter(
        models.Member.company_uid == admin_member.company_uid
    ).all()

    today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
    team_status = []

    for member in members:
        if member.user_uid == admin_uid:
            continue

        latest = db.query(models.Attendance).filter(
            models.Attendance.account_uid == member.account_uid,
            models.Attendance.created_at >= today_start
        ).order_by(desc(models.Attendance.created_at)).first()

        team_status.append({
            "profile": serialize_member_profile(member),
            "todayAttendance": serialize_attendance(latest)
        })

    return team_status

def admin_fetch_job_counts(db, admin_uid):
    """Fetch job statistics"""
    admin_member = db.query(models.Member).filter(
        models.Member.user_uid == admin_uid
    ).first()

    if not admin_member:
        raise AppException("Admin profile not found")

    company_uid = admin_member.company_uid

    pending = db.query(models.Job).filter(
        models.Job.company_uid == company_uid,
        models.Job.status.in_([JobStatus.pending, JobStatus.assigned])
    ).count()

    in_progress = db.query(models.Job).filter(
        models.Job.company_uid == company_uid,
        models.Job.status == JobStatus.in_progress
    ).count()

    completed = db.query(models.Job).filter(
        models.Job.company_uid == company_uid,
        models.Job.status == JobStatus.completed
    ).count()

    cancelled = db.query(models.Job).filter(
        models.Job.company_uid == company_uid,
        models.Job.status == JobStatus.cancelled
    ).count()

    return {
        "pending": pending,
        "inProgress": in_progress,
        "completed": completed,
        "cancelled": cancelled
    }

# ... similar functions for other data
```

#### Step 2: Create use case function

```python
# use_cases/admin_use_cases.py

from services.data_access import (
    admin_fetch_team_status_today,
    admin_fetch_job_counts,
    admin_fetch_recent_jobs,
    admin_fetch_chart_data
)

def build_admin_dashboard(db, admin_uid):
    """
    Aggregate all dashboard data
    """
    team_status = admin_fetch_team_status_today(db, admin_uid)
    job_counts = admin_fetch_job_counts(db, admin_uid)
    recent_jobs = admin_fetch_recent_jobs(db, admin_uid, limit=10)
    chart_data = admin_fetch_chart_data(db, admin_uid)

    return {
        "teamMembersStatus": team_status,
        "jobCounts": job_counts,
        "recentJobs": recent_jobs,
        "jobChart": chart_data
    }
```

#### Step 3: Update endpoint

```python
# api/v1/admin/dashboard.py

from use_cases.admin_use_cases import build_admin_dashboard

@router.get("", response_model=GenericResponse)
async def get_dashboard(
    db: Session = Depends(get_db),
    admin: models.User = Depends(get_admin_user)
):
    """Thin endpoint - just orchestrate and respond"""
    data = build_admin_dashboard(db, admin.uid)
    return GenericResponse(
        success=True,
        message="Dashboard data fetched successfully",
        data=data
    )
```

---

## Testing Strategy

### 1. Unit Tests for Data Access Functions

```python
# tests/test_data_access.py

def test_admin_fetch_team_status_today():
    # Mock DB, admin_uid
    # Assert returns correct structure

def test_admin_fetch_team_status_today_invalid_admin():
    # Should raise AppException
```

### 2. Integration Tests for Use Cases

```python
# tests/test_use_cases.py

def test_build_admin_dashboard():
    # Full database with data
    # Call use case
    # Verify all sections present
```

### 3. Endpoint Tests (Unchanged)

```python
# tests/test_endpoints.py

def test_get_admin_dashboard():
    # Should return same response as before
    # Status should be same
    # Data structure should be same
```

---

## Rollback Strategy

Each phase can be rolled back independently:

- **Phase 1 (Data Access)**: Delete `services/data_access.py` → No impact
- **Phase 2 (Use Cases)**: Delete `use_cases/` folder → Endpoints still work with old services
- **Phase 3 (Endpoints)**: Revert route files to use old services → Tests verify no API change

---

## Success Criteria

✅ All endpoints return same response format (backward compatible)  
✅ Code is cleaner - endpoints are now 10-15 lines  
✅ Logic is centralized - easier to maintain  
✅ Easier to test - data access functions are unit testable  
✅ Easier to extend - add new data access functions without changing endpoints  
✅ No performance degradation  
✅ All existing tests pass

---

## Timeline

| Phase     | Task                               | Estimate         | Status          |
| --------- | ---------------------------------- | ---------------- | --------------- |
| 1         | Create data_access.py              | 2 hours          | Ready to start  |
| 2         | Create use_cases layer             | 3 hours          | Pending Phase 1 |
| 3         | Refactor dashboard endpoints       | 1 hour           | Pending Phase 2 |
| 4         | Refactor jobs endpoints            | 2 hours          | Pending Phase 3 |
| 5         | Refactor attendance endpoints      | 1.5 hours        | Pending Phase 4 |
| 6         | Refactor profile endpoints         | 1 hour           | Pending Phase 5 |
| 7         | Refactor auth endpoints            | 1 hour           | Pending Phase 6 |
| 8         | Refactor company/members endpoints | 1.5 hours        | Pending Phase 7 |
| 9         | Write tests                        | 4 hours          | Pending Phase 8 |
| 10        | Integration testing & cleanup      | 2 hours          | Pending Phase 9 |
| **TOTAL** |                                    | **~19-20 hours** |                 |

---

## Next Steps

1. ✅ **Review this plan** - Make sure approach aligns with requirements
2. **Approve structure** - Confirm folder organization and function naming
3. **Start Phase 1** - Create data_access.py with dashboard functions
4. **Create Unit Tests** - For each new data access function
5. **Refactor Dashboard** - Update endpoints to use new structure
6. **Verify with Frontend** - Ensure no API changes
7. **Repeat for other features**

---

## Questions to Clarify

1. Should we keep all existing service files or consolidate?
2. Do you want error handling in data access or use cases?
3. Should we use dependency injection for cleaner testing?
4. Any specific naming conventions to follow?
5. Should we add logging/monitoring to data access layer?

---

**Last Updated**: May 12, 2026  
**Prepared for**: Trackyond Backend Team  
**Status**: Ready for Approval & Implementation
