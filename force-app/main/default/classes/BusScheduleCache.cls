/**
 * @author          cubiascaceres
 * @description     Platform Cache basics module
 */
public with sharing class BusScheduleCache {

    private Cache.OrgPartition part;

    /**
    * @description 
    * @author cubiascaceres | 04-08-2022 
    **/
    public BusScheduleCache() {
        part = Cache.Org.getPartition('local.BusSchedule');
    }

    /**
    * @description 
    * @author cubiascaceres | 04-08-2022 
    * @param busLine 
    * @param schedule 
    **/
    public void putSchedule(String busLine, Time[] schedule) {
        this.part.put(busLine, schedule);
    }

    /**
    * @description 
    * @author cubiascaceres | 04-08-2022 
    * @param busLine 
    * @return Time[] 
    **/
    public Time[] getSchedule(String busLine) {
        Time[] schedule = (Time[]) this.part.get(busLine);
        if (schedule != null) {
            return schedule;
        } else {
            return new Time[]{ Time.newInstance(8, 0, 0, 0), Time.newInstance(17, 0, 0, 0) };
        }
    }
}
