class ProductsDatatable
  delegate :params, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    products_relation = products
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Product.count,
      iTotalDisplayRecords: @total_filtered || products_relation.count,
      aaData: data
    }
  end

private

  def data
    products.map do |product|
      [
        link_to(product.name, product),
        ERB::Util.html_escape(product.category.name),
        ERB::Util.html_escape(product.released_on.strftime("%B %e, %Y")),
        number_to_currency(product.price)
      ]
    end
  end

  def products
    @products ||= fetch_products
    @products
  end

  def fetch_products
    products = Product.joins(:category).order("#{sort_column} #{sort_direction}")

    if params[:sSearch].present?
      search = "%#{params[:sSearch]}%"
      # use ILIKE for case-insensitive search on Postgres
      products = products.where("products.name ILIKE :search OR categories.name ILIKE :search", search: search)
    end

    # store the total number of records matching the filter (before pagination)
    @total_filtered = products.count

    # apply DataTables pagination (start = offset, length = limit)
    offset = (params[:start] || 0).to_i
    limit  = (params[:length] || 10).to_i
    products.offset(offset).limit(limit)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
