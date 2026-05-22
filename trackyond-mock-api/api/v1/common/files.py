from fastapi import APIRouter, HTTPException, File, UploadFile, Form
from fastapi.responses import FileResponse
from services.file_service import resolve_download_path
import os
import shutil
import uuid
from core.responses.models import GenericResponse

router = APIRouter(prefix="/files", tags=["Common/Files"])

@router.post("/upload", response_model=GenericResponse)
async def upload_file(
    file: UploadFile = File(...),
    path: str = Form(...) # e.g., 'companyUid/jobUid'
):
    """
    Generic endpoint to upload a file.
    Expects a form-data payload with the file and a target path.
    """
    try:
        clean_path = path.strip("/")
        upload_dir = os.path.join("uploads", clean_path)
        os.makedirs(upload_dir, exist_ok=True)

        _, ext = os.path.splitext(file.filename)
        # Use a unique filename if none is implied, but here we can just use the provided or generate a generic one.
        # Let's generate a unique filename to avoid collisions, or use original.
        filename = f"{uuid.uuid4().hex}{ext}"
        
        file_path = os.path.join(upload_dir, filename)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # Return the relative path to be used with the download endpoint
        relative_path = f"uploads/{clean_path}/{filename}"
        
        return GenericResponse(
            success=True,
            message="File uploaded successfully",
            data=relative_path
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/download/{file_path:path}")
async def download_file(file_path: str):
    """
    Generic endpoint to download any file by its path.
    Example: /api/v1/common/files/download/uploads/comp_A/user_3/avatar.jpg
    """
    abs_path, status_code, error = resolve_download_path(file_path)
    if error:
        raise HTTPException(status_code=status_code, detail=error)

    return FileResponse(abs_path)

