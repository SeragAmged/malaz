CREATE OR REPLACE VIEW room_members_with_session AS
SELECT
  rm.id,
  rm.room_id,
  rm.user_id,
  rm.status,
  rm.joined_at,
  rm.last_checkin_at,
  p.full_name,
  p.avatar_url,
  ps.id AS session_id,
  ps.session_type,
  ps.started_at,
  ps.planned_minutes,
  ps.paused_at,
  ps.total_paused_seconds,
  COALESCE((
    SELECT SUM(
      EXTRACT(EPOCH FROM (s.ended_at - s.started_at))::int
      - s.total_paused_seconds
    )
    FROM pomodoro_sessions s
    WHERE s.user_id = rm.user_id
      AND s.room_id = rm.room_id
      AND s.session_type = 'focus'
      AND s.ended_at IS NOT NULL
      AND s.started_at >= rm.last_checkin_at
  ), 0) AS completed_focus_seconds
FROM room_members rm
JOIN profiles p ON p.id = rm.user_id
LEFT JOIN pomodoro_sessions ps
  ON ps.user_id = rm.user_id
  AND ps.room_id = rm.room_id
  AND ps.ended_at IS NULL;
