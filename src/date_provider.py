import os
from datetime import timedelta, datetime, date

apollo_datetime_format = '%Y/%m/%d'
check_datetime_format = '%Y%m%d'

def is_today_a_holiday():
    today_date = date.today().strftime(check_datetime_format)
    return is_holiday(today_date)

def is_holiday(date_str):
    year = date_str[0:4]

    root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    official_holiday_filepath = f'{root}/config/holidays/{year}.txt'

    try:
        with open(official_holiday_filepath, 'r') as f:
            holiday = f.read()
            if date_str in holiday:
                return True
            else:
                return False
    except Exception as e:
        print(e)
        # If error occurs, assume input day is working day :)
        return False

def get_working_dates_in_range(start_date_str, end_date_str):
    start_date = datetime.strptime(start_date_str, apollo_datetime_format).date()
    end_date = datetime.strptime(end_date_str, apollo_datetime_format).date()
    
    date_list = []

    for n in range(int((end_date - start_date).days) + 1):
        next_day = start_date + timedelta(n)

        if not is_holiday(next_day.strftime(check_datetime_format)):
            date_list.append(next_day.strftime(apollo_datetime_format))
    
    return date_list