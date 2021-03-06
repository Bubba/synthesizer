import Foundation
import AudioToolbox

/// Effect
/// Handles applying Core Audio effects to the sound generated by `Synthesizer`s
public enum Effect {
	/// Highpass
	/// Cuts off frequencies higher than the specified amount
	/// - cutoff: the frequency in Hertz to cutoff at
	case highPass(cutoff: Float32)
	/// Lowpass
	/// Cuts off frequencies lower than the specified amount
	/// - cutoff: the frequency in Hertz to cutoff at
	case lowPass(cutoff: Float32)
	/// Delay
	/// Repeats the audio similar to an echo
	/// - delayTime: the time in seconds after at which the first delay is heard
	/// - dryWetMix: the mix from 0 to 100 of "wet" and "dry" delay
	/// - feedback: the amount from 0 to 100 that each delay should feedback into the next one
	case delay(delayTime: Float32, wetDryMix: Float32, feedback: Float32)
	/// Reverb
	/// Causes audio to "linger", giving the effect of playing sound in a large space
	/// - smallLargeMix: the mix from 0 to 100 of the small and large reverbs
	/// - dryWetMix: the mix from 0 to 100 of "wet" and "dry" delay
	/// - preDelay: the time in seconds for the pre delay
	case reverb(smallLargeMix: Float32, dryWetMix: Float32, preDelay: Float32)
	/// Distortion
	/// Distorts the sound
	/// - decimation: the amount from 0 to 100 that the sound should be decimated by
	/// - decimationMix: the mix from 0 to 100 of the decimated sound
	/// - ringModMix: the mix from 0 to 100 of the ring modulation effect
	/// - finalMix: the mix from 0 to 100 of the original sound to the distorted sound
	case distortion(decimation: Float32, decimationMix: Float32, ringModMix: Float32, finalMix: Float32)
	
	var description: AudioComponentDescription {
		switch self {
		case .highPass:
			return AudioComponentDescription(componentType: kAudioUnitType_Effect,
			                                 componentSubType: kAudioUnitSubType_HighPassFilter,
			                                 componentManufacturer: kAudioUnitManufacturer_Apple,
			                                 componentFlags: 0, componentFlagsMask: 0)
		case .lowPass:
			return AudioComponentDescription(componentType: kAudioUnitType_Effect,
			                                 componentSubType: kAudioUnitSubType_LowPassFilter,
			                                 componentManufacturer: kAudioUnitManufacturer_Apple,
			                                 componentFlags: 0, componentFlagsMask: 0)
		case .delay:
			return AudioComponentDescription(componentType: kAudioUnitType_Effect,
			                                 componentSubType: kAudioUnitSubType_Delay,
			                                 componentManufacturer: kAudioUnitManufacturer_Apple,
			                                 componentFlags: 0, componentFlagsMask: 0)
		case .reverb:
			return AudioComponentDescription(componentType: kAudioUnitType_Effect,
			                                 componentSubType: kAudioUnitSubType_MatrixReverb,
			                                 componentManufacturer: kAudioUnitManufacturer_Apple,
			                                 componentFlags: 0, componentFlagsMask: 0)
		case .distortion:
			return AudioComponentDescription(componentType: kAudioUnitType_Effect,
			                                 componentSubType: kAudioUnitSubType_Distortion,
			                                 componentManufacturer: kAudioUnitManufacturer_Apple,
			                                 componentFlags: 0, componentFlagsMask: 0)
		}
	}
	
	func setParameters(unit: inout AudioUnit) {
		switch self {
		case .highPass(let cutoff):
			AudioUnitSetParameter(unit, kHipassParam_CutoffFrequency, kAudioUnitScope_Global, 0, cutoff, 0)
		case .lowPass(let cutoff):
			AudioUnitSetParameter(unit, kLowPassParam_CutoffFrequency, kAudioUnitScope_Global, 0, cutoff, 0)
		case .delay(let delayTime, let wetDryMix, let feedback):
			AudioUnitSetParameter(unit, kDelayParam_DelayTime, kAudioUnitScope_Global, 0, delayTime, 0)
			AudioUnitSetParameter(unit, kDelayParam_WetDryMix, kAudioUnitScope_Global, 0, wetDryMix, 0)
			AudioUnitSetParameter(unit, kDelayParam_Feedback, kAudioUnitScope_Global, 0, feedback, 0)
		case .reverb(let smallLargeMix, let dryWetMix, let preDelay):
			AudioUnitSetParameter(unit, kReverbParam_SmallLargeMix, kAudioUnitScope_Global, 0, smallLargeMix, 0)
			AudioUnitSetParameter(unit, kReverbParam_DryWetMix, kAudioUnitScope_Global, 0, dryWetMix, 0)
			AudioUnitSetParameter(unit, kReverbParam_PreDelay, kAudioUnitScope_Global, 0, preDelay, 0)
		case .distortion(let decimation, let decimationMix, let ringModMix, let finalMix):
			AudioUnitSetParameter(unit, kDistortionParam_Decimation, kAudioUnitScope_Global, 0, decimation, 0)
			AudioUnitSetParameter(unit, kDistortionParam_DecimationMix, kAudioUnitScope_Global, 0, decimationMix, 0)
			AudioUnitSetParameter(unit, kDistortionParam_RingModMix, kAudioUnitScope_Global, 0, ringModMix, 0)
			AudioUnitSetParameter(unit, kDistortionParam_FinalMix, kAudioUnitScope_Global, 0, finalMix, 0)

		}
	}
}
