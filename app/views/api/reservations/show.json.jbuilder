json.reservation do
  json.id @reservation.id
  json.created_at @reservation.created_at
  json.updated_at @reservation.updated_at
  json.status @reservation.status
  json.start_date @reservation.start_date
  json.end_date @reservation.end_date
  json.guest @reservation.guest
  json.room @reservation.room
  json.reservation_code @reservation[:reservation_code]
  json.user_id @reservation[:user_id]
end
