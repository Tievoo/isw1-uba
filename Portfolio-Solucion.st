!classDefinition: #PortfolioTest category: #'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: #'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'T 10/29/2024 02:15:02'!
test08TransferChangesAccountValues
	| account1 account2 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount  new.
	
	Transfer of: 100 extractFrom: account1 depositTo: account2.
	
	self assert: (account1 balance) equals: -100.
	self assert: (account2 balance) equals: 100.	 
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'T 10/29/2024 02:28:36'!
test09TransferLegsExistInAccounts
	| account1 account2 transfer |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount  new.
	
	transfer := Transfer of: 100 extractFrom: account1 depositTo: account2.
	
	self assert: (account1 hasRegistered:  transfer extractLeg).
	self assert: (account2 hasRegistered:  transfer depositLeg).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'T 10/29/2024 02:37:41'!
test10LegsCanFindEachOther
	| account1 account2 transfer |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount  new.
	
	transfer := Transfer of: 100 extractFrom: account1 depositTo: account2.
	
	self assert: (transfer extractLeg findOppositeLeg) equals: (transfer depositLeg ).
! !


!classDefinition: #ReportTest category: #'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 16:47:18'!
test00EmptyAccountEmptySummary
	| account summary |
	
	account := ReceptiveAccount new.	summary := (AccountSummary for:account) generate.

	self assert: (summary at: 1) equals: ('Balance = 0')! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 16:48:20'!
test01AccountSummaryReadsDeposits

	| account summary|
	
	account := ReceptiveAccount new.
	
	Deposit register: 100 on: account .
	
	summary := (AccountSummary for: account) generate .
	
	self assert: (summary includes: 'Depósito por 100')! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 16:49:03'!
test02AccountSummaryReadsWithdraws

	| account summary |
	
	account := ReceptiveAccount new.
	
	Withdraw register: 100 on: account .
	
	summary := (AccountSummary for: account) generate .
	
	self assert: (summary includes: 'Extracción por 100')! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 16:50:18'!
test03AccountSummaryReadsTransfers

	| account1 account2 summary1 summary2 |
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: account1 depositTo: account2 .
	summary1 := (AccountSummary for: account1) generate .
	summary2 := (AccountSummary for: account2) generate .
	
	self assert: (summary1 includes: 'Salida por transferencia de 100').
	self assert: (summary2 includes: 'Entrada por transferencia de 100')! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 16:51:37'!
test04AccountSummaryReadsEverything

	| account summary res |
	
	account := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: account depositTo: (ReceptiveAccount new) .
	Deposit  register: 150 on: account .
	Withdraw register: 40 on: account .
	
	summary := (AccountSummary for: account) generate .
	
	res := OrderedCollection with: 'Salida por transferencia de 100' with: 'Depósito por 150' with: 'Extracción por 40' with: 'Balance = 10'.
	
	self assert: (summary = res).
	! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:03:12'!
test05EmptyAccountEmptyNet

	| net |
	
	net := (TransferNet for: (ReceptiveAccount new)) generate.
	
	
	self assert: (net) equals: 0! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:04:47'!
test06TransferNetReadsDepositLegs
	| account net |
	
	account := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: (ReceptiveAccount new) depositTo: account.
	
	net := (TransferNet for: account) generate.
	
	self assert: (net) equals: 100! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:05:25'!
test07TransferNetReadsExtractLegs

	| account net |
	
	account := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: account depositTo: (ReceptiveAccount new).
	net := (TransferNet for: account) generate.
	
	self assert: (net) equals: -100! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:17:15'!
test08TransferNetReadsBothThings

	| account net |
	
	account := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: account depositTo: (ReceptiveAccount new).
	Transfer of: 200 extractFrom: (ReceptiveAccount new) depositTo: account.
	
	net := (TransferNet for: account) generate.
	
	self assert: (net) equals: 100! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:19:50'!
test09TransferNetReadsIgnoresDepositsAndWithdraws

	| account net |
	
	account := ReceptiveAccount new.
	
	Transfer of: 100 extractFrom: account depositTo: (ReceptiveAccount new).
	Transfer of: 200 extractFrom: (ReceptiveAccount new) depositTo: account.
	
	Deposit register: 300 on: account.
	Withdraw register: 31 on: account. 
	
	net := (TransferNet for: account) generate.
	
	self assert: (net) equals: 100! !

!ReportTest methodsFor: 'tests' stamp: 'T 11/1/2024 17:37:18'!
test10AccountSummaryWorksOnPortfolios
	| portfolio account1 account2 res summary |
	
	res := OrderedCollection with: 'Depósito por 100' with: 'Extracción por 100' with: 'Balance = 0'.
	
	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	
	Deposit register: 100 on: account1 .
	Withdraw register: 100 on: account2.
	
	portfolio := Portfolio with: account1 with: account2.
	
	summary := (AccountSummary for: portfolio) generate.
	
	self assert: summary equals: res! !


!classDefinition: #AccountTransaction category: #'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'operate' stamp: 'T 11/1/2024 16:35:13'!
operate: aReportGenerator

	self subclassResponsibility! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: #'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/21/2019 18:54:27'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: #'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'value' stamp: 'T 10/29/2024 19:51:12'!
value

	^ value! !


!Deposit methodsFor: 'initialization' stamp: 'T 10/29/2024 19:53:05'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'operate' stamp: 'T 11/1/2024 16:35:34'!
operate: aReportGenerator
	aReportGenerator operateOnDeposit: self.
	 ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: #'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Leg category: #'Portfolio-Solucion'!
AccountTransaction subclass: #Leg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Leg methodsFor: 'legs' stamp: 'T 10/29/2024 02:59:11'!
findOppositeLeg

	self subclassResponsibility! !


!Leg methodsFor: 'balance' stamp: 'T 10/29/2024 03:20:55'!
affectBalance: aBalance

	self subclassResponsibility! !


!Leg methodsFor: 'value' stamp: 'T 10/29/2024 19:48:10'!
value
	^transfer value.! !


!Leg methodsFor: 'initialization' stamp: 'T 10/29/2024 19:49:55'!
initializeWithTransfer: aTransfer
	transfer := aTransfer .! !


!Leg methodsFor: 'operate' stamp: 'T 11/1/2024 16:35:18'!
operate: aReportGenerator

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Leg class' category: #'Portfolio-Solucion'!
Leg class
	instanceVariableNames: ''!

!Leg class methodsFor: 'instance creation' stamp: 'T 10/29/2024 19:49:19'!
on: account withTransfer: aTransfer

	| leg |
	
	leg := self new initializeWithTransfer: aTransfer.
	account register: leg.
		
	^leg! !


!classDefinition: #DepositLeg category: #'Portfolio-Solucion'!
Leg subclass: #DepositLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositLeg methodsFor: 'legs' stamp: 'T 10/29/2024 03:02:48'!
findOppositeLeg
	^transfer extractLeg.! !


!DepositLeg methodsFor: 'balance' stamp: 'T 10/29/2024 20:03:33'!
affectBalance: aBalance
	^aBalance + self value.! !


!DepositLeg methodsFor: 'operate' stamp: 'T 11/1/2024 16:36:32'!
operate: aReportGenerator
	aReportGenerator operateOnDepositLeg: self.
	 ! !


!classDefinition: #ExtractLeg category: #'Portfolio-Solucion'!
Leg subclass: #ExtractLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ExtractLeg methodsFor: 'legs' stamp: 'T 10/29/2024 03:02:40'!
findOppositeLeg
	^transfer depositLeg .! !


!ExtractLeg methodsFor: 'balance' stamp: 'T 10/29/2024 20:03:38'!
affectBalance: aBalance
	^aBalance - self value.
	! !


!ExtractLeg methodsFor: 'operate' stamp: 'T 11/1/2024 16:36:26'!
operate: aReportGenerator
	aReportGenerator operateOnExtractLeg: self.
	 ! !


!classDefinition: #Withdraw category: #'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'value' stamp: 'T 10/29/2024 19:51:30'!
value
	^value.! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'initialization' stamp: 'T 10/29/2024 19:53:13'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'operate' stamp: 'T 11/1/2024 16:35:48'!
operate: aReportGenerator
	aReportGenerator operateOnWithdraw: self.
	 ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: #'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialAsset category: #'Portfolio-Solucion'!
Object subclass: #FinancialAsset
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!FinancialAsset methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!FinancialAsset methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!FinancialAsset methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!FinancialAsset methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!FinancialAsset methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!FinancialAsset methodsFor: 'operate' stamp: 'T 11/1/2024 16:32:02'!
operateOnTransactions: aReportGenerator

	self subclassResponsibility! !


!FinancialAsset methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: #'Portfolio-Solucion'!
FinancialAsset subclass: #Portfolio
	instanceVariableNames: 'assets parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'T 10/29/2024 02:12:36'!
accountsIncludes: anAccount

	^assets includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'T 10/29/2024 02:12:35'!
accountsIsEmpty
	
	^assets isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'T 10/29/2024 02:12:35'!
accountsSize
	
	^assets size! !

!Portfolio methodsFor: 'accounts management' stamp: 'T 10/29/2024 02:12:35'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	assets add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'T 10/29/2024 02:12:35'!
initialize

	assets := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'T 10/29/2024 02:12:35'!
balance
	
	^assets sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'T 10/29/2024 02:12:35'!
addTransactionsTo: aCollectionOfTransactions

	assets do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'T 10/29/2024 02:12:35'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	assets do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'T 10/29/2024 02:12:35'!
hasRegistered: aTransaction

	^assets anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'T 10/29/2024 02:12:35'!
isComposedBy: anAccount

	^ self = anAccount or: [ assets anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !


!Portfolio methodsFor: 'operate' stamp: 'T 11/1/2024 16:34:27'!
operateOnTransactions: aReportGenerator
	assets do: [ :anAsset | anAsset operateOnTransactions: aReportGenerator ]
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: #'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: #'Portfolio-Solucion'!
FinancialAsset subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'reports' stamp: 'T 10/29/2024 19:43:55'!
accountSummary
	| summary  message |
	summary := OrderedCollection new.
	transactions do: [ :aTransaction |
		(aTransaction class = Deposit) ifTrue: [message := 'Depósito por ', (aTransaction value asString)].
		(aTransaction class = Withdraw) ifTrue: [message := 'Extracción por ', (aTransaction value asString)].
		(aTransaction class = DepositLeg) ifTrue: [message := 'Entrada por transferencia de ', (aTransaction value asString)].
		(aTransaction class = ExtractLeg) ifTrue: [message := 'Salida por transferencia de ', (aTransaction value asString)].
		summary add: message .
	].
	summary add: ('Balance = ', self balance asString).
	^summary.! !

!ReceptiveAccount methodsFor: 'reports' stamp: 'T 10/29/2024 20:00:48'!
transferNet
	| total |
	total := 0.
	transactions do: [ :aTransaction |
		total := aTransaction affectBalance: total.
	].

	^total.! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'operate' stamp: 'T 11/1/2024 16:33:18'!
operateOnTransactions: aReportGenerator
	^transactions do: [ :aTransaction | aTransaction operate: aReportGenerator ].
	! !


!classDefinition: #TransactionReport category: #'Portfolio-Solucion'!
Object subclass: #TransactionReport
	instanceVariableNames: 'financialAsset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransactionReport methodsFor: 'initialization' stamp: 'T 11/1/2024 16:47:03'!
initializeFor: aFinancialAsset

	financialAsset := aFinancialAsset .! !


!TransactionReport methodsFor: 'report' stamp: 'T 11/1/2024 16:38:41'!
generate

	self subclassResponsibility! !


!TransactionReport methodsFor: 'operations' stamp: 'T 11/1/2024 16:28:23'!
operateOnDeposit: aDeposit

	self subclassResponsibility! !

!TransactionReport methodsFor: 'operations' stamp: 'T 11/1/2024 16:28:27'!
operateOnDepositLeg: aDepositLeg

	self subclassResponsibility! !

!TransactionReport methodsFor: 'operations' stamp: 'T 11/1/2024 16:28:31'!
operateOnExtractLeg: aExtractLeg

	self subclassResponsibility! !

!TransactionReport methodsFor: 'operations' stamp: 'T 11/1/2024 16:28:34'!
operateOnWithdraw: aWithdraw

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransactionReport class' category: #'Portfolio-Solucion'!
TransactionReport class
	instanceVariableNames: ''!

!TransactionReport class methodsFor: 'instance creation' stamp: 'T 11/1/2024 16:28:50'!
for: aFinancialAsset
	  ^self new initializeFor: aFinancialAsset .! !


!classDefinition: #AccountSummary category: #'Portfolio-Solucion'!
TransactionReport subclass: #AccountSummary
	instanceVariableNames: 'summary'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'summary' stamp: 'T 11/1/2024 16:42:31'!
stringOnBalance
	^'Balance = ', financialAsset balance asString.! !

!AccountSummary methodsFor: 'summary' stamp: 'T 11/1/2024 16:43:16'!
stringOnDeposit: aDeposit
	^'Depósito por ', aDeposit value asString! !

!AccountSummary methodsFor: 'summary' stamp: 'T 11/1/2024 16:43:59'!
stringOnDepositLeg: aDepositLeg
	^'Entrada por transferencia de ', aDepositLeg value asString! !

!AccountSummary methodsFor: 'summary' stamp: 'T 11/1/2024 16:44:10'!
stringOnExtractLeg: anExtractLeg
	^'Salida por transferencia de ', anExtractLeg value asString! !

!AccountSummary methodsFor: 'summary' stamp: 'T 11/1/2024 16:43:42'!
stringOnWithdraw: aWithdraw
	^'Extracción por ', aWithdraw value asString! !


!AccountSummary methodsFor: 'operations' stamp: 'T 11/1/2024 16:40:40'!
operateOnDeposit: aDeposit
	summary add: (self stringOnDeposit: aDeposit ).! !

!AccountSummary methodsFor: 'operations' stamp: 'T 11/1/2024 16:40:51'!
operateOnDepositLeg: aDepositLeg
	summary add: (self stringOnDepositLeg: aDepositLeg ).! !

!AccountSummary methodsFor: 'operations' stamp: 'T 11/1/2024 16:41:06'!
operateOnExtractLeg: anExtractLeg
	summary add: (self stringOnExtractLeg: anExtractLeg ).! !

!AccountSummary methodsFor: 'operations' stamp: 'T 11/1/2024 16:41:22'!
operateOnWithdraw: aWithdraw
	summary add: (self stringOnWithdraw: aWithdraw ).! !


!AccountSummary methodsFor: 'report' stamp: 'T 11/1/2024 16:40:19'!
generate
	summary := OrderedCollection new.
	financialAsset operateOnTransactions: self.
	summary add: (self stringOnBalance ).
	^summary! !


!classDefinition: #TransferNet category: #'Portfolio-Solucion'!
TransactionReport subclass: #TransferNet
	instanceVariableNames: 'balance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'operations' stamp: 'T 11/1/2024 17:38:29'!
operateOnDeposit: aDeposit
	" Does nothing "
	^balance.! !

!TransferNet methodsFor: 'operations' stamp: 'T 11/1/2024 17:01:55'!
operateOnDepositLeg: aDepositLeg
	balance := aDepositLeg affectBalance: balance! !

!TransferNet methodsFor: 'operations' stamp: 'T 11/1/2024 17:01:50'!
operateOnExtractLeg: aExtractLeg
	balance := aExtractLeg affectBalance: balance! !

!TransferNet methodsFor: 'operations' stamp: 'T 11/1/2024 17:38:36'!
operateOnWithdraw: aWithdraw
	" Does nothing "
	^balance.! !


!TransferNet methodsFor: 'report' stamp: 'T 11/1/2024 17:03:37'!
generate
	balance := 0.
	financialAsset operateOnTransactions: self.
	^balance.! !


!classDefinition: #Transfer category: #'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'extractLeg depositLeg value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'getters' stamp: 'T 10/29/2024 02:32:09'!
depositLeg
	^depositLeg.! !

!Transfer methodsFor: 'getters' stamp: 'T 10/29/2024 02:32:11'!
extractLeg
	^extractLeg.! !


!Transfer methodsFor: 'value' stamp: 'T 10/29/2024 19:48:26'!
value
	^value.! !


!Transfer methodsFor: 'initialization' stamp: 'T 10/29/2024 19:50:21'!
initializeOf: anAmount extractFrom: accountToExtractFrom depositTo: accountToDepositTo
	extractLeg := ExtractLeg on: accountToExtractFrom  withTransfer: self.
	depositLeg := DepositLeg on: accountToDepositTo  withTransfer: self.
	value := anAmount.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: #'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'T 10/29/2024 02:22:37'!
of: anAmount extractFrom: accountToExtractFrom depositTo: accountToDepositTo 
	
	^self new initializeOf: anAmount extractFrom: accountToExtractFrom depositTo: accountToDepositTo .
	! !
