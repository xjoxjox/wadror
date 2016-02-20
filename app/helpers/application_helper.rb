module ApplicationHelper
  def edit_and_destroy_buttons(item)
    unless current_user.nil?
      edit = link_to('Edit', url_for([:edit, item]), class:"btn btn-primary")
      if is_admin
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class:"btn btn-danger")
      else
        del = nil
      end
      raw("#{edit} #{del}")
    end
  end

  def round(x)
    number_with_precision(x, precision: 1)
  end
end
