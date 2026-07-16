import csv
with open ('orders.csv','r',encoding='utf-8') as file:
    reader = csv.DictReader(file)
    
    total_users = {}
    count_users = {}
    users_country = {}

    total_countrys = {}
    count_country = {}

    total_categoryes = {}

    count_orders ={}
    orders_country = {}
    users_orders_country = {}

    midlle_country = {}

    for i in reader:
        if (
            not i["CustomerID"] or
            not i["UnitPrice"] or
            not i["Quantity"] or
            not i["Country"] or 
            not i['Description'] or
            not i['StockCode'] or 
            not i['InvoiceDate']
        ):
            continue

        CustomerID= i['CustomerID']
        Price = float(i['UnitPrice'])
        Country = i['Country']
        Quantity = float(i['Quantity'])
        Category = i['Description']

        if CustomerID not in total_users:
            total_users[CustomerID] = 0
            count_users[CustomerID] = 0

            users_country[CustomerID] = Country

        total_users[CustomerID] += Price * Quantity
        count_users[CustomerID] += 1

        if Country  not in total_countrys:
            total_countrys[Country] = 0 
            count_country[Country] = 0

        total_countrys[Country] += Price * Quantity
        count_country[Country] += 1

        if Category  not in total_categoryes:
            total_categoryes[Category] = 0 

        total_categoryes[Category] += Price * Quantity

        if Quantity not in count_orders:
            count_orders[Quantity] = 0
            
            orders_country[Quantity] = Country
            users_orders_country[Quantity] = CustomerID

        count_orders[Quantity] += 1
    
for CustomerID, total in total_users.items():
    itog_amount = ((f'{CustomerID} : {users_country[CustomerID]} : {round(total,2)}'))
    print(itog_amount)

print('top_10_users :\n')
top_10_users = sorted(total_users.items(),
                      key= lambda x : x[1],
                      reverse=True)
for CustomerID,revenue in top_10_users[:10]:
    print(f'{CustomerID} : {users_country[CustomerID]} : {round(revenue,2)}')

print('count_users')
for CustomerID, totales in count_users.items():
    itog_count_us = ((f'{CustomerID} : {users_country[CustomerID]} : {round(totales,2)}'))
    print(itog_count_us)

print('top_10_countries : \n')
top_10_countries = sorted(total_countrys.items(),
                      key= lambda x : x[1],
                      reverse=True)
for Country,total_country in top_10_countries[:10]:
    print(f'{Country} : {round(total_country,2)}')

print( )
print('count_countres')
for Country, totaless in count_country.items():
    itog_count_countries = ((f'{Country} : {round(totaless,2)}'))
    print(itog_count_countries)

print( )
print('top_10_categories :\n')
top_10_categories = sorted(total_categoryes.items(),
                      key= lambda x : x[1],
                      reverse=True)
for Category,total_categor  in top_10_categories[:10]:
    print(f'{Category} : {round(total_categor,2)}')

print( )
print('count_orders')
for Quantity, totls in count_orders.items():
    itog_count_orders = ((f'{users_orders_country[Quantity]} : {orders_country[Quantity]} : {round(totls,2)}'))
    print(itog_count_orders)

print( )
print('middle_country: ')
for Country,values in total_countrys.items():
    midlle_country[Country] = round(
        total_countrys[Country] / 
        count_country[Country],2
    )
sort_middle_country = sorted(midlle_country.items(),
                             key= lambda x : x [1],
                             reverse=True)
print(sort_middle_country)



















