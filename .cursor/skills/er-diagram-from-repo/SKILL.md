---
name: er-diagram-from-repo
description: >-
  I1 ER diagram from repo — tables, entities, PKs, FKs, Mermaid diagram with
  source file citations. Use for data model mapping, schema discovery, or I1
  on any service with ORM models or SQL migrations.
---

# ER diagram from repo (I1)

Build an **ER diagram from code only** — migrations, ORM entities, schema SQL. Cite a source file for every table and relationship.

## Procedure

1. Search sources (in order):
   - Flyway/Liquibase: `db/migration`, `resources/db`
   - JPA/Hibernate: `@Entity`, `@Table`
   - SQLAlchemy: `declarative_base`, models
   - Prisma/TypeORM: `schema.prisma`, entities
   - Raw SQL in repo
2. For each table/entity: **name, PK, columns (key ones), FKs or inferred joins**.
3. Note **non-SQL stores** (Redis keys, ES indices) in a separate section — not in Mermaid ER unless relational.
4. Draw **valid Mermaid `erDiagram`** block.
5. Mark uncertainty (`inferred`, `not mapped in JPA`) explicitly.

## Output template

`<output-dir>/I1-er-diagram.md`:

```markdown
# I1 — ER Diagram: {service-name}

> Note if no in-repo migrations (external DBA schema, etc.)

## Tables and entities
| Table | Entity | Source file | Primary key |

## Columns (key fields)
| Column | Entity field | Type | Notes |

## Relationships
| From | To | Type | Evidence (file:line or query) |

## Non-relational stores (if any)
| Key / index | Source | Purpose |

## Mermaid ER diagram
\`\`\`mermaid
erDiagram
  TABLE_A {
    string id PK
  }
  TABLE_B {
    string id PK
    string a_id FK
  }
  TABLE_A ||--o{ TABLE_B : "relationship"
\`\`\`

## Agent suggested vs manually verified
| Item | Agent | Manual |
|------|-------|--------|
| Entity count | code search | ✅ opened N source files |
```

## Reference

Example: `PM4-6558-assignment/evidence/I/I1-er-diagram.md`.
