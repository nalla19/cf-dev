<!--- -----------------------------------------setup the default session vals----------------------------------------- --->
<cflock scope="session" timeout="10" type="Exclusive">
	<cfparam name="session.ER.shoppingCart.Status" default="0">
	<cfparam name="session.ER.shoppingCart.IOC_TransID" default="">
	<cfparam name="session.ER.shoppingCart.EmployerID" default="">
	<cfparam name="session.ER.shoppingCart.FirstName" default="">
	<cfparam name="session.ER.shoppingCart.LastName" default="">
	<cfparam name="session.ER.shoppingCart.Email" default="">
	<cfparam name="session.ER.shoppingCart.Phone" default="">
	<cfparam name="session.ER.shoppingCart.Fax" default="">
	<cfparam name="session.ER.shoppingCart.BillingSame" default="1">
	<cfparam name="session.ER.shoppingCart.CardType" default="">
	<cfparam name="session.ER.shoppingCart.CardNumber" default="">
	<cfparam name="session.ER.shoppingCart.CardMonth" default="">
	<cfparam name="session.ER.shoppingCart.CardYear" default="">
	<cfparam name="session.ER.shoppingCart.CSC" default="">
	<cfparam name="session.ER.shoppingCart.CardOwner" default="">
	<cfparam name="session.ER.shoppingCart.CCCompany" default="">
	<cfparam name="session.ER.shoppingCart.CCaddress1" default="">
	<cfparam name="session.ER.shoppingCart.CCaddress2" default="">
	<cfparam name="session.ER.shoppingCart.CCCity" default="">
	<cfparam name="session.ER.shoppingCart.CCState" default="">
	<cfparam name="session.ER.shoppingCart.strCCState" default="">
	<cfparam name="session.ER.shoppingCart.CCCountry" default="">
	<cfparam name="session.ER.shoppingCart.CCzip" default="">
	<cfparam name="session.ER.shoppingCart.autoRenew" default="">
	<cfparam name="session.ER.shoppingCart.PurchasePrice" default="0.00">
	<cfparam name="session.ER.shoppingCart.TotalPurchasePrice" default="0.00">
	<cfparam name="session.ER.shoppingCart.PackagePurchased" default="">
	<cfparam name="session.ER.shoppingCart.DateSubmitted" default="">
</cflock>

<cfparam name="blnSearch" default="0">


<cfparam name="strFirstName" default="">
<cfparam name="strLastName" default="">
<cfparam name="strHowFind" default="">
<cfparam name="intERTrkID" default="0">
<cfparam name="strPromoCode" default="">
<cfparam name="strUsername" default="">
<cfparam name="strOrigUsername" default="">
<cfparam name="strPassword" default="">
<cfparam name="strconfirm_password" default="">


<!--- -----------------------------------------contact info----------------------------------------- --->
<cfparam name="strCompanyName" default="">
<cfparam name="strAddress1" default="">
<cfparam name="strAddress2" default="">
<cfparam name="strCity" default="">
<cfparam name="intState" default="">
<cfparam name="strState" default="">
<cfparam name="strCountry" default="">
<cfparam name="strZip" default="">
<cfparam name="strPhone" default="">
<cfparam name="strFax" default="">
<cfparam name="strEmail" default="">
<cfparam name="strOrigEmail" default="">
<cfparam name="blnExeRec" default="">
<cfparam name="strURL" default="">


<!--- -----------------------------------------Billing Info (if different from contact)----------------------------------------- --->
<cfparam name="intSameAsContact" default="1">
<cfparam name="strBillCompany" default="">
<cfparam name="strBillAddress1" default="">
<cfparam name="strBillAddress2" default="">
<cfparam name="strBillCity" default="">
<cfparam name="strBillState" default="">
<cfparam name="strBillCountry" default="">
<cfparam name="strBillZip" default="">
<cfparam name="strBillPhone" default="">
<cfparam name="strBillFax" default="">
<cfparam name="strBillEmail" default="">
