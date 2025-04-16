import psycopg2

def create_db(conn):
    with conn.cursor() as cur:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS clients (
            id SERIAL PRIMARY KEY,
            first_name VARCHAR(50),
            last_name VARCHAR(50),
            email VARCHAR(100) UNIQUE
        );
        """)
        cur.execute("""
        CREATE TABLE IF NOT EXISTS phones (
            id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
            phone VARCHAR(20)
        );
        """)
        conn.commit()

def add_client(conn, first_name, last_name, email, phones=None):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO clients (first_name, last_name, email)
        VALUES (%s, %s, %s)
        RETURNING id;
        """, (first_name, last_name, email))
        client_id = cur.fetchone()[0]
        if phones:
            for phone in phones:
                cur.execute("""
                INSERT INTO phones (client_id, phone)
                VALUES (%s, %s);
                """, (client_id, phone))
        conn.commit()
        return client_id

def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO phones (client_id, phone)
        VALUES (%s, %s);
        """, (client_id, phone))
        conn.commit()

def change_client(conn, client_id, first_name=None, last_name=None, email=None, phones=None):
    with conn.cursor() as cur:
        if first_name:
            cur.execute("UPDATE clients SET first_name=%s WHERE id=%s;", (first_name, client_id))
        if last_name:
            cur.execute("UPDATE clients SET last_name=%s WHERE id=%s;", (last_name, client_id))
        if email:
            cur.execute("UPDATE clients SET email=%s WHERE id=%s;", (email, client_id))
        if phones is not None:
            cur.execute("DELETE FROM phones WHERE client_id=%s;", (client_id,))
            for phone in phones:
                cur.execute("INSERT INTO phones (client_id, phone) VALUES (%s, %s);", (client_id, phone))
        conn.commit()

def delete_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""
        DELETE FROM phones WHERE client_id=%s AND phone=%s;
        """, (client_id, phone))
        conn.commit()

def delete_client(conn, client_id):
    with conn.cursor() as cur:
        cur.execute("DELETE FROM clients WHERE id=%s;", (client_id,))
        conn.commit()

def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:
        query = """
        SELECT c.id, c.first_name, c.last_name, c.email, p.phone
        FROM clients c
        LEFT JOIN phones p ON c.id = p.client_id
        WHERE TRUE
        """
        params = []
        if first_name:
            query += " AND c.first_name = %s"
            params.append(first_name)
        if last_name:
            query += " AND c.last_name = %s"
            params.append(last_name)
        if email:
            query += " AND c.email = %s"
            params.append(email)
        if phone:
            query += " AND p.phone = %s"
            params.append(phone)
        cur.execute(query, tuple(params))
        return cur.fetchall()

if __name__ == '__main__':
    with psycopg2.connect(database="netology_db", user="postgres", password="postgres") as conn:
        create_db(conn)

        # Добавление клиентов
        client_id1 = add_client(conn, "Иван", "Иванов", "ivan@example.com", ["12345", "67890"])
        client_id2 = add_client(conn, "Анна", "Петрова", "anna@example.com")

        # Добавление телефона
        add_phone(conn, client_id2, "99999")

        # Изменение данных клиента
        change_client(conn, client_id1, email="newivan@example.com", phones=["11111"])

        # Поиск клиента
        print("Поиск по имени:", find_client(conn, first_name="Анна"))

        # Удаление телефона
        delete_phone(conn, client_id1, "11111")

        # Удаление клиента
        delete_client(conn, client_id2)

    conn.close()