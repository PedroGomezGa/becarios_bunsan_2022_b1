defmodule InvoiceValidatorTest do
  use ExUnit.Case
  import InvoiceValidator 

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)
  @base_tz "Mexico/General"
  @base_time ~N[2022-03-23 15:06:35]   

  data = [
{"72 hrs antes",  "America/Tijuana",     ~N[2022-03-20 14:06:31], :fail},
{"72 hrs antes",  "America/Mazatlan",    ~N[2022-03-20 14:06:31], :fail},
{"72 hrs antes",  "America/Mexico_City", ~N[2022-03-20 15:06:31], :fail},
{"72 hrs antes",  "America/Cancun",      ~N[2022-03-20 14:06:31], :fail},
{"72 hrs antes",  "America/Tijuana",     ~N[2022-03-20 14:06:35], :succes},
{"72 hrs antes",  "America/Mazatlan",    ~N[2022-03-20 14:06:35], :succes},
{"72 hrs antes",  "America/Mexico_City", ~N[2022-03-20 15:06:35], :succes},
{"72 hrs antes",  "America/Cancun",      ~N[2022-03-20 16:06:35], :succes},
{"5 mns despues", "America/Tijuana",     ~N[2022-03-23 14:11:35], :succes},
{"5 mns despues", "America/Mazatlan",    ~N[2022-03-23 14:11:35], :succes},
{"5 mns despues", "America/Mexico_City", ~N[2022-03-23 15:11:35], :succes},
{"5 mns despues", "America/Cancun",      ~N[2022-03-23 16:11:35], :succes},
{"5 mns despues", "America/Tijuana",     ~N[2022-03-23 14:11:36], :fail},
{"5 mns despues", "America/Mazatlan",    ~N[2022-03-23 14:11:36], :fail},
{"5 mns despues", "America/Mexico_City", ~N[2022-03-23 15:11:36], :fail},
{"5 mns despues", "America/Cancun",      ~N[2022-03-23 16:11:36], :fail},
{"72 hrs y un seg antes", "Mexico/General", ~N[2022-03-20 15:06:34], :fail},
{"72 hrs antes exactas", "Mexico/General", ~N[2022-03-20 15:06:35], :succes}, 
{"un segundo antes de las 72 hrs", "Mexico/General", ~N[2022-03-20 15:06:36], :succes},
{"un segundo antes de los 5 mns", "Mexico/General", ~N[2022-03-23 15:11:34], :succes},
{"5 mns exactos", "Mexico/General", ~N[2022-03-23 15:11:35], :succes},
{"5 mns y un segundo", "Mexico/General", ~N[2022-03-23 15:11:36], :fail}
]

  for {t, tz, dt, exp} <- data do
    @t t
    @tz tz
    @dt dt
    @exp exp
    test "#{@t}, emisor in #{@tz} at #{@dt} returns #{@exp}" do
      assert @exp == InvoiceValidator.validate_dates(datetime(@dt, @tz), datetime(@base_time, @base_tz))
      end
  end

  def datetime(%NaiveDateTime{} = ndt, tz) do
    DateTime.from_naive!(ndt, tz)
  end
end
