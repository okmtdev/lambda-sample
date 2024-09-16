from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware
from mangum import Mangum

_app = FastAPI()


@_app.get("/health", include_in_schema=True)
async def health():
    print("Called")
    return "ok"


app = CORSMiddleware(
    app=_app,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# これだけ
handler = Mangum(app, lifespan="off")
