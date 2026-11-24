-- Stage 4: first table for time-series readings.
-- One row per measurement: when, which system, what was measured, the value.

CREATE TABLE readings (
    ts      timestamptz      NOT NULL,  -- time of the snapshot (UTC)
    source  text             NOT NULL,  -- e.g. 'victron', 'ebusd'
    metric  text             NOT NULL,  -- e.g. 'grid_power_w'
    value   double precision            -- numeric reading
);

-- Speeds up the usual question: "this metric, from this source, over this time range".
CREATE INDEX readings_source_metric_ts ON readings (source, metric, ts);
