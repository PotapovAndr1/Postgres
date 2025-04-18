# main.py (объединяет задания 2 и 3)
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Publisher, Book, Shop, Stock, Sale, Base

# Настройки подключения к БД
DSN = "postgresql://postgres:Zapret123!@localhost:5432/bookstore"
engine = create_engine(DSN)
Session = sessionmaker(bind=engine)
session = Session()

def load_test_data(json_file):
    """Задание 3: Загрузка тестовых данных из JSON с проверкой существующих записей"""
    try:
        with open(json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        model_mapping = {
            'publisher': Publisher,
            'book': Book,
            'shop': Shop,
            'stock': Stock,
            'sale': Sale
        }
        
        for record in data:
            model = model_mapping[record['model']]
            # Проверяем, существует ли запись с таким ID
            existing = session.query(model).get(record['pk'])
            if not existing:
                session.add(model(id=record['pk'], **record['fields']))
            else:
                print(f"Запись {record['model']} с ID {record['pk']} уже существует, пропускаем")
        
        session.commit()
        print(f"Тестовые данные из {json_file} успешно обработаны!")
    except Exception as e:
        session.rollback()
        print(f"Ошибка при загрузке данных: {e}")

def find_publisher_sales():
    """Задание 2: Поиск продаж по издателю"""
    publisher_input = input("Введите имя или ID издателя: ").strip()
    
    try:
        # Определяем, введен ID или имя
        if publisher_input.isdigit():
            publisher = session.query(Publisher).get(int(publisher_input))
        else:
            publisher = session.query(Publisher).filter(
                Publisher.name.ilike(f"%{publisher_input}%")
            ).first()
        
        if not publisher:
            print("Издатель не найден!")
            return
        
        # Получаем данные о продажах
        sales = session.query(
            Book.title,
            Shop.name,
            Sale.price,
            Sale.date_sale
        ).select_from(Publisher)\
         .join(Book, Book.id_publisher == Publisher.id)\
         .join(Stock, Stock.id_book == Book.id)\
         .join(Shop, Shop.id == Stock.id_shop)\
         .join(Sale, Sale.id_stock == Stock.id)\
         .filter(Publisher.id == publisher.id)\
         .order_by(Sale.date_sale.desc()).all()
        
        if not sales:
            print(f"ℹНет данных о продажах для издателя '{publisher.name}'")
            return
        
        # Форматированный вывод
        print(f"\nПродажи книг издателя '{publisher.name}':")
        print("-" * 70)
        print(f"{'Книга':<25} | {'Магазин':<15} | {'Цена':<6} | Дата")
        print("-" * 70)
        for title, shop, price, date in sales:
            print(f"{title:<25} | {shop:<15} | {price:<6} | {date.strftime('%d-%m-%Y')}")
        print("-" * 70)
    except Exception as e:
        print(f"Ошибка при выполнении запроса: {e}")

def main():
    """Главное меню программы"""
    while True:
        print("\n" + "="*30)
        print("1. Загрузить тестовые данные")
        print("2. Найти продажи по издателю")
        print("3. Выйти")
        print("="*30)
        
        choice = input("Выберите действие (1-3): ").strip()
        
        if choice == "1":
            json_file = input("Введите путь к JSON-файлу (по умолчанию: tests_data.json): ").strip()
            load_test_data(json_file or "tests_data.json")
        elif choice == "2":
            find_publisher_sales()
        elif choice == "3":
            break
        else:
            print("Некорректный ввод! Попробуйте снова.")
    
    session.close()
    print("Работа программы завершена")

if __name__ == "__main__":
    # Создаем таблицы, если их нет
    Base.metadata.create_all(engine)
    
    # Запускаем главное меню
    main()