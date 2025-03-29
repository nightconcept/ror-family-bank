defmodule FamilyBankWeb.PageHTML do
  use FamilyBankWeb, :html

  import FamilyBankWeb.NumberHelpers

  embed_templates "page_html/*"
end
