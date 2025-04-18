import os
from sqlalchemy import (
    Column, Integer, String, ForeignKey, Float, DateTime, create_engine
)
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class Publisher(Base):
    __tablename__ = 'publisher'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False, unique=True)

    books = relationship('Book', back_populates='publisher')

class Book(Base):
    __tablename__ = 'book'
    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    id_publisher = Column(Integer, ForeignKey('publisher.id'), nullable=False)

    publisher = relationship('Publisher', back_populates='books')
    stocks = relationship('Stock', back_populates='book')

class Shop(Base):
    __tablename__ = 'shop'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False, unique=True)

    stocks = relationship('Stock', back_populates='shop')

class Stock(Base):
    __tablename__ = 'stock'
    id = Column(Integer, primary_key=True)
    id_book = Column(Integer, ForeignKey('book.id'), nullable=False)
    id_shop = Column(Integer, ForeignKey('shop.id'), nullable=False)
    count = Column(Integer, nullable=False)

    book = relationship('Book', back_populates='stocks')
    shop = relationship('Shop', back_populates='stocks')
    sales = relationship('Sale', back_populates='stock')

class Sale(Base):
    __tablename__ = 'sale'
    id = Column(Integer, primary_key=True)
    price = Column(Float, nullable=False)
    date_sale = Column(DateTime, nullable=False)
    id_stock = Column(Integer, ForeignKey('stock.id'), nullable=False)
    count = Column(Integer, nullable=False)

    stock = relationship('Stock', back_populates='sales')

# Параметры подключения к БД
DB_USER = os.getenv('DB_USER', 'postgres')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'Zapret123!')
DB_NAME = os.getenv('DB_NAME', 'bookstore')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')

DSN = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
engine = create_engine(DSN)

# 👉 Функция создания таблиц
def create_tables(engine):
    Base.metadata.create_all(engine)

# Тест запуска
if __name__ == '__main__':
    create_tables(engine)
