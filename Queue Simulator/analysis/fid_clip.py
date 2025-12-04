import torch
import open_clip

class QualityEvaluator:
    def __init__(self):
        self.model, _, self.preprocess = open_clip.create_model_and_transforms(
            "ViT-B-32", pretrained="openai"
        )
        self.tokenizer = open_clip.get_tokenizer("ViT-B-32")

    def compute_clip_self(self, image):
        """Compute CLIPScore of image against its own features (consistency)."""
        img = self.preprocess(image).unsqueeze(0)

        with torch.no_grad():
            img_feat = self.model.encode_image(img)
            score = (img_feat @ img_feat.T).item()

        return float(score)
