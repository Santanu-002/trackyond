import redis
import os

# Redis configuration
redis_url = os.getenv("REDIS_URL", "redis://redis:6379/0")
r = redis.from_url(redis_url, decode_responses=True)

def get_redis():
    return r
