# -*- coding: utf-8 -*-
"""
Created on Sat May 27 20:39:02 2023

@author: Aneesh R Bhat
"""

total_cost=  float(input("Enter the total cost of your dream house: "))
portion_down_payment = 0.25*total_cost
current_savings = 0
r = 0.04
annual_salary = float(input("Enter your annual salary: "))
semi_annual_raise = float(input('Enter your semi-annual raise as a decimal: '))
portion_saved = float(input("Enter the portion of your salary you'll save: "))

no_of_months=0

while current_savings < portion_down_payment:
    if no_of_months%6 == 0 and no_of_months!=0:
        annual_salary += annual_salary*semi_annual_raise
    no_of_months+= 1
    monthly_salary = annual_salary/12
    monthly_savings = portion_saved*monthly_salary
    return_this_month = current_savings*(r/12)
    current_savings += monthly_savings+return_this_month
    print(no_of_months, monthly_salary, annual_salary)
    
    
    

print("Number of months:", no_of_months)


    
    
    
    



