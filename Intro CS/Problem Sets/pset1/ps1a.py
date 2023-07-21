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
portion_saved = float(input("Enter the portion of your salary you'll save: "))
monthly_salary = annual_salary/12
monthly_savings = portion_saved*monthly_salary
no_of_months=0

while current_savings < portion_down_payment:
    return_this_month = current_savings*(r/12)
    current_savings += monthly_savings+return_this_month
    no_of_months+= 1

print("Number of months:", no_of_months)


    
    
    
    



