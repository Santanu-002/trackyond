from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
import os

router = APIRouter(prefix="/common", tags=["common"])

@router.get("/download/avatar/{company_uid}/{user_uid}")
async def download_avatar(company_uid: str, user_uid: str):
    """
    Public endpoint to download a member's avatar image.
    In the future, this can be extended with authentication logic.
    """
    file_path = os.path.join("uploads", company_uid, user_uid, "avatar.jpg")
    
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="Avatar not found")
        
    return FileResponse(file_path)
