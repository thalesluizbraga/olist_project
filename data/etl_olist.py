#%%
from sqlalchemy import create_engine, text


# %%
engine = create_engine('sqlite:///bd_olist.sqlite', echo=True, future=True)
conn = engine.connect()
result = conn.execute(text('select * from tb_orders'))

for row in result:
    print(row)


# %%