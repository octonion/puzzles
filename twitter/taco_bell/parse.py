import csv,json
  
f = open('taco_bell.json',)
  
data = json.load(f)

file = open('taco_bell.csv', 'w')
writer = csv.writer(file)

for cat in data['menuProductCategories']:
    cat_code = cat['code']
    cat_name = cat['name']
    for p in cat['products']:
        product_code = p['code']
        product_name = p['name']
        product_calories = p['calories']
        product_price = p['price']['value']
        row = [cat_code,cat_name,product_code,
               product_name,product_calories,product_price]
        writer.writerow(row)
  
f.close()
