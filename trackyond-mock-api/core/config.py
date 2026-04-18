import os

# OTP Configuration
SECRET_KEY = os.getenv("SECRET_KEY", "trackyond_secret_key_change_in_production")
OTP_EXPIRY_SECONDS = int(os.getenv("OTP_EXPIRY_SECONDS", "600"))

# JWT Configuration
JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "trackyond_jwt_secret_change_in_production")
JWT_ALGORITHM = "HS256"
JWT_ACCESS_EXPIRE_MINUTES = int(os.getenv("JWT_ACCESS_EXPIRE_MINUTES", "10"))
JWT_REFRESH_EXPIRE_DAYS = int(os.getenv("JWT_REFRESH_EXPIRE_DAYS", "7"))
