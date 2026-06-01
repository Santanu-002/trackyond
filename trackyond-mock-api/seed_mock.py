import sys
import os
from sqlalchemy.orm import Session

# Add current directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from db.database import SessionLocal
from db import models
from core.constants.enums import UserRole

def seed():
    db = SessionLocal()
    try:
        # Check if users already exist to avoid duplicate errors
        owner_user = db.query(models.User).filter(models.User.uid == '98258ed8f8').first()
        if not owner_user:
            owner_user = models.User(
                uid='98258ed8f8',
                phone='+919999999999',
                role=UserRole.owner,
                is_new_user=False,
                primary_profile_uid='eed5c8f9b2'
            )
            db.add(owner_user)

        db.flush()

        company = db.query(models.Company).filter(models.Company.company_id == 'comp_f0529da0').first()
        if not company:
            company = models.Company(
                company_id='comp_f0529da0',
                name='Mock Company',
                owner_uid='98258ed8f8',
                team_size=10
            )
            db.add(company)

        db.flush()

        owner_member = db.query(models.Member).filter(models.Member.uid == 'eed5c8f9b2').first()
        if not owner_member:
            owner_member = models.Member(
                uid='eed5c8f9b2',
                user_uid='98258ed8f8',
                company_uid='comp_f0529da0',
                name='Mock Admin',
                phone='+919999999999',
                designation='Owner',
                is_active=True
            )
            db.add(owner_member)

        db.commit()
        print("Mock owner/company data seeded successfully (worker removed)!")
    except Exception as e:
        db.rollback()
        print(f"Error seeding mock data: {e}")
        raise e
    finally:
        db.close()

if __name__ == "__main__":
    seed()
