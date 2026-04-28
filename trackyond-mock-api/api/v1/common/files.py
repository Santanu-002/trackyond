from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
import os

router = APIRouter(prefix="/files", tags=["Common/Files"])

@router.get("/download/{file_path:path}")
async def download_file(file_path: str):
    """
    Generic endpoint to download any file by its path.
    Example: /api/v1/common/files/download/uploads/comp_A/user_3/avatar.jpg
    """
    # Remove leading slash if present
    clean_path = file_path.lstrip("/")
    
    # Normalize path
    normalized_path = os.path.normpath(clean_path)
    
    if not os.path.exists(normalized_path):
        raise HTTPException(status_code=404, detail=f"File not found: {normalized_path}")
        
    if not os.path.isfile(normalized_path):
        raise HTTPException(status_code=400, detail=f"Path is not a file: {normalized_path}")
        
    return FileResponse(normalized_path)
