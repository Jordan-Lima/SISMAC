use actix_cors::Cors;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use validator::Validate;
use serde::{Deserialize, Serialize};
use sqlx::{PgPool, FromRow};
use dotenvy::dotenv;
use std::env;

#[derive(Deserialize, Validate)]
pub struct MacRequest {
    #[validate(length(min = 1))]
    pub name: String,
    #[validate(length(min = 1))]
    pub sector: String,
    #[validate(length(min = 1))]
    pub store: String,
    pub mac: String,
}

#[derive(Serialize, FromRow)]
pub struct MacEntry {
    pub id: i64,
    pub name: String,
    pub sector: String,
    pub store: String,
    pub mac: String,
}

#[derive(Serialize)]
pub struct MacResponse {
    pub status: String,
    pub message: String,
}

#[post("/mac")]
async fn add_mac(
    db:web::Data<PgPool>,
    mac_request: web::Json<MacRequest>,
) -> impl Responder {
    let result = sqlx::query(
        "INSERT INTO mac_address (name, sector, store, mac) VALUES ($1, $2, $3, $4)"
    )
    .bind(&mac_request.name)
    .bind(&mac_request.sector)
    .bind(&mac_request.store)
    .bind(&mac_request.mac)
    .execute(db.get_ref())
    .await;

    match result {
        Ok(_) => HttpResponse::Ok().json(MacResponse {
            status: "success".to_string(),
            message: "MAC registrado com sucesso".to_string(),
        }),
        Err(e) => HttpResponse::InternalServerError().json(MacResponse {
            status: "error".to_string(),
            message: format!("Erro ao registar MAC: {}", e),
        }),
    }
}

#[get("/macs")]
async fn get_macs(db: web::Data<PgPool>) -> impl Responder {
    let result = sqlx::query_as::<_, MacEntry>("SELECT * FROM mac_address")
        .fetch_all(db.get_ref())
        .await;

    match result {
        Ok(macs) => HttpResponse::Ok().json(macs),
        Err(e) => HttpResponse::InternalServerError().json(MacResponse {
            status: "error".to_string(),
            message: format!("Erro ao buscar MACs: {}", e),
        }),
    }
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();

    let db_url = env::var("DATABASE_URL").expect("DATABASE_URL não definida");
    let pool = PgPool::connect(&db_url)
        .await
        .expect("Erro ao conectar ao banco");

    HttpServer::new(move|| {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .wrap(Cors::permissive())
            .service(add_mac)
            .service(get_macs)
    })
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}
