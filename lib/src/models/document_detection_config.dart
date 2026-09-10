/// Configuration for document alignment detection thresholds used by
/// [DocumentDetectionService] during auto-capture.
final class DocumentDetectionConfig {
  /// Minimum ratio of the detected object area to the frame area.
  ///
  /// Objects smaller than this threshold are considered too far from the camera
  /// and trigger a "Move closer" hint. Defaults to `0.50` (50 %).
  final double minSizeRatio;

  /// Maximum ratio of the detected object area to the frame area.
  ///
  /// Objects larger than this threshold are considered too close and trigger a
  /// "Move farther away" hint. Defaults to `0.70` (70 %).
  final double maxSizeRatio;

  /// Position tolerance as a fraction of the frame bounds.
  ///
  /// `0.0` means the detected object must lie strictly within the frame.
  /// Increase slightly (e.g. `0.05`) to allow a minor border overrun.
  /// Defaults to `0.0`.
  final double frameTolerance;

  /// Minimum time that must elapse between two processed camera frames.
  ///
  /// The camera stream can deliver frames much faster than the on-screen
  /// guidance needs to update (e.g. 30-60 fps). Frames arriving before this
  /// interval has elapsed since the last processed one are skipped, which
  /// reduces both detector CPU usage and how often the guidance status can
  /// change. Set to [Duration.zero] to process every frame (the pre-existing
  /// behavior). Defaults to `200ms`.
  final Duration frameProcessingInterval;

  /// Minimum time a new, non-aligned guidance status must remain stable
  /// before it replaces the currently displayed one.
  ///
  /// This smooths out rapid back-and-forth changes between guidance
  /// messages (e.g. "Move closer" / "Move left") so consuming apps that bind
  /// UI directly to the status notifiers don't see it flicker multiple times
  /// per second. It does not delay the transition into or out of
  /// [DocumentDetectionStatus.aligned] — that transition (and therefore the
  /// auto-capture debounce) always applies immediately, so capture reliability
  /// and promptness are unaffected. Defaults to `450ms`.
  final Duration statusHoldDuration;

  const DocumentDetectionConfig({
    this.minSizeRatio = 0.50,
    this.maxSizeRatio = 0.70,
    this.frameTolerance = 0.0,
    this.frameProcessingInterval = const Duration(milliseconds: 200),
    this.statusHoldDuration = const Duration(milliseconds: 450),
  }) : assert(minSizeRatio >= 0.0 && minSizeRatio <= 1.0),
       assert(maxSizeRatio > 0.0 && maxSizeRatio <= 1.0),
       assert(minSizeRatio < maxSizeRatio),
       assert(frameTolerance >= 0.0 && frameTolerance <= 1.0);
}
