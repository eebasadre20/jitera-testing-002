json.total_pages @total_pages
json.reservations @reservations do |reservation|
  json.id reservation.id
  json.created_at reservation.created_at
  json.updated_at reservation.updated_at
end
