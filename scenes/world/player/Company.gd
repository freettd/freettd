class_name Company

signal bank_balance_changed()

enum CompanyType {
	LOCAL,
	REMOTE
	AI,
}

enum ExpenseType {
	CONSTRUCTION,
	OTHER
}

var bank_balance: int = 0
var company_type: int

# does the company have enough money
func can_afford(cost: int) -> bool:
	return bank_balance >= cost
	
# add expense
func add_expense(cost: int, expense_type: int = ExpenseType.OTHER) -> void:
	bank_balance -= cost
	emit_signal("bank_balance_changed")

func get_save_data() -> Dictionary:
	return {
		company_type = company_type,
		bank_balance = bank_balance
	}

# load company from savefile
func load_data(company_data: Dictionary) -> void:
	bank_balance = company_data.bank_balance
	company_type = company_data.company_type
