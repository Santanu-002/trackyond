from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
from services.file_service import resolve_download_path

router = APIRouter(prefix="/files", tags=["Common/Files"])

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
