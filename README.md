#  CF Company Manager

CF Company Manager is a web-based company and employee experience management system developed using **Adobe ColdFusion (CFML)** and **Microsoft SQL Server**.  
The project focuses on CRUD operations, relational database design, and a structured company review platform with rating and feedback functionality.

---

##  Overview

This project simulates a real-world internal company management and employee review system.  
Users can manage company records and submit structured reviews including ratings for salary, benefits, work-life balance, management quality, career growth, and overall experience.

The main goal was to build a complete backend-driven web application using ColdFusion while applying secure database practices and modern UI structure.

---

##  Technologies

- Adobe ColdFusion (CFML)
- Microsoft SQL Server
- HTML5 & CSS3
- JavaScript
- FontAwesome

---

##  Features

- Company CRUD Management (Create, Read, Update, Delete)
- Relational database structure with foreign keys
- Star-based rating system (1–5 scale)
- Employee experience review module
- Anonymous review option
- Statistical rating averages
- Dynamic forms & modern card-based UI
- Secure queries using `cfqueryparam`

---

##  Database Structure

Main Tables:

- COMPANY
- Kullanicilar
- Yorumlar

Relationships:
Yorumlar.SirketSymbol → COMPANY.Symbol
Yorumlar.KullaniciID → Kullanicilar.ID


Includes:

- Primary Keys
- Foreign Keys
- Check Constraints
- Cascading Deletes

---

##  Installation

1. Install Adobe ColdFusion Server
2. Move project into ColdFusion `wwwroot`
3. Create SQL Server database
4. Run SQL scripts
5. Configure ColdFusion datasource
6. Run:http://localhost/.../deneme.cfm


---

##  Screenshots



