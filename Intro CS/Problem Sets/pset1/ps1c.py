# -*- coding: utf-8 -*-
"""
Created on Sun May 28 09:41:20 2023

@author: Aneesh R Bhat
"""

total_cost = 1000000
down_payment = 0.25*total_cost
r = 0.04
semi_raise = 0.07
no_of_months = 36
to_save = 0
annual_income = float(input("Enter your annual income: "))
beg = 0
end = 10000
mid = int((beg+end)/2)
iterations = 0
max_iterations = 3000
while end >= beg and iterations <= max_iterations:
    starting_income = annual_income
    current_savings = 0
    for i in range(0, no_of_months):
        portion = mid/10000
        if i%6 == 0 and i!=0:
            starting_income += starting_income*semi_raise
        monthly_salary = starting_income/12
        monthly_savings = portion*monthly_salary
        monthly_return = current_savings*(r/12)
        current_savings += monthly_savings+monthly_return
    
    if abs(down_payment - current_savings) <= 100:
        print(mid/10000, "is the correct answer")
        print("No. of iterations: ", iterations+1)
        break
    elif current_savings < down_payment-100:
        beg = int(mid)
    else:
        end = int(mid)
    iterations += 1
    mid = int((beg+end)/2)

    
if iterations > max_iterations:
    print("Savings portion not found within given number of iterations")