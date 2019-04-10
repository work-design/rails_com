Time::DATE_FORMATS[:date] = ->(time){
  t = Time.zone.at time
  t.strftime '%Y-%m-%d'
}
Time::DATE_FORMATS[:datetime] = '%Y-%m-%d %H:%M'
Date::DATE_FORMATS[:date] = ->(date){
  date.strftime '%Y-%m-%d'
}
