class_name Company

signal bank_balance_changed()

enum ExpenseType {
	CONSTRUCTION,
	OTHER
}

var bank_balance: int = 0

func can_afford(cost: int) -> bool:
	return bank_balance >= cost
	

func add_expense(cost: int, expense_type: int = ExpenseType.OTHER) -> void:
	bank_balance -= cost
	emit_signal("bank_balance_changed")
