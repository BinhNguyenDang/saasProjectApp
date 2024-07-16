module ApplicationHelper

  def class_name_for_account_form(account)
    return "cc_form" if account.payment.blank?
    ""
  end
end
