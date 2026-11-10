import pandas as pd

df = pd.read_excel("data/Online Retail.xlsx")

print("Shape:", df.shape)
print("\nColumns:", df.columns.tolist())
print("\nFirst five rows:")
print(df.head())
print("\nData types:")
print(df.dtypes)

df.to_csv(
    "data/online_retail.csv",
    index=False,
    encoding="utf-8"
)

print("CSV export completed.")