from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(redoc_url=None)

# Enable CORS for all routes
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def hello():
    return {"message": "Hello World"}
