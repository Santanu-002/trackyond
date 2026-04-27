from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
import os

router = APIRouter(prefix="/v1/common", tags=["common"])

@router.get("/download/{file_path:path}")
async def download_file(file_path: str):
    """
    Generic endpoint to download any file by its path.
    Example: /api/v1/common/download/uploads/comp_A/user_3/avatar.jpg
    """
    # Remove leading slash if present to ensure it's treated as relative to the app root
    clean_path = file_path.lstrip("/")
    
    # Normalize path
    normalized_path = os.path.normpath(clean_path)
    
    print(f"DEBUG: Request to download: {file_path} -> Cleaned: {clean_path} -> Normalized: {normalized_path}")
    print(f"DEBUG: CWD: {os.getcwd()}")
    print(f"DEBUG: Exists: {os.path.exists(normalized_path)}, IsFile: {os.path.isfile(normalized_path)}")
    
    if not os.path.exists(normalized_path):
        raise HTTPException(status_code=404, detail=f"File not found: {normalized_path}")
        
    if not os.path.isfile(normalized_path):
        raise HTTPException(status_code=400, detail=f"Path is not a file: {normalized_path}")
        
    return FileResponse(normalized_path)
