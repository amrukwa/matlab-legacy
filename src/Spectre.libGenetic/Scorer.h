#pragma once
#include <memory>
#include "DataTypes.h"
#include "FitnessFunction.h"

namespace Spectre::libGenetic
{
class Scorer
{
public:
    Scorer(Scorer&&) = default;
    explicit Scorer(std::unique_ptr<FitnessFunction> fitnessFunction);
    std::vector<ScoreType> Score(const Generation& generation);
private:
    std::unique_ptr<FitnessFunction> m_FitnessFunction;
};
}
