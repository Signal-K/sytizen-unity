create table
  public."inventory" (
    id bigint generated by default as identity,
    item bigint null, 
    owner uuid null,
    quantity double precision null,
    -- location bigint null,
    -- sector bigint null,
    -- "planetSector" bigint null,
    notes text null,
    time_of_deploy timestamp with time zone null,
    "anomaly" bigint null,
    constraint inventory_pkey primary key (id),
    -- constraint inventory_item_fkey foreign key (item) references "inventoryITEMS" (id),
    -- constraint inventory_location_fkey foreign key (location) references "inventoryPLANETS" (id),
    constraint inventory_anomaly_fkey foreign key ("anomaly") references "anomalies" (id),
    -- constraint inventory_planetSector_fkey foreign key ("planetSector") references "basePlanetSectors" (id),
    -- constraint inventory_sector_fkey foreign key (sector) references "basePlanetSectors" (id),
    constraint inventory_owner_fkey foreign key (owner) references profiles (id)
) tablespace pg_default;