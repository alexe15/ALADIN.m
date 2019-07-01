/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
 *                            K.U. Leuven. All rights reserved.
 *    Copyright (C) 2011-2014 Greg Horn
 *
 *    CasADi is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    CasADi is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with CasADi; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef CASADI_POLYNOMIAL_HPP
#define CASADI_POLYNOMIAL_HPP

# include "printable_object.hpp"

namespace casadi {

  /** \brief Helper class for differentiating and integrating polynomials
      \author Joel Andersson
      \date 2014
  */
  class CASADI_EXPORT Polynomial : public PrintableObject<Polynomial> {
  public:
    /// Floating point type
    typedef double real_t;

    /// Construct a constant polynomial
    Polynomial(real_t scalar=1);

    /// Construct a linear polynomial
    Polynomial(real_t p0, real_t p1);

    /// Construct a quadratic polynomial
    Polynomial(real_t p0, real_t p1, real_t p2);

    /// Construct a cubic polynomial
    Polynomial(real_t p0, real_t p1, real_t p2, real_t p3);

    /// Construct from a vector of polynomial coefficients
    template<typename T>
    Polynomial(const std::vector<T>& coeff) : p_(coeff.begin(), coeff.end()) {}

    /// Evaluate numerically
    template<typename T>
    T operator()(const T& x) const {
      auto it = p_.rbegin();
      T ret = *it++;
      while (it!=p_.rend()) {
        ret *= x;
        ret += *it++;
      }
      return ret;
    }

    /// Degree of the polynomial
    int degree() const;

    /// Get scalar value (error if degree()!=0)
    real_t scalar() const;

    /// Create a new polynomial for the derivative
    Polynomial derivative() const;

    /// Create a new polynomial for the anti-derivative (primitive function)
    Polynomial anti_derivative() const;

    /// Remove excess zeros
    void trim();

    /// Print a description of the object
    void print(std::ostream &stream=casadi::userOut(), bool trailing_newline=true) const;

    /// Print a representation of the object
    void repr(std::ostream &stream=casadi::userOut(), bool trailing_newline=true) const;

    // Add
    Polynomial operator+(const Polynomial& b) const;

    // Add (in-place)
    Polynomial& operator+=(const Polynomial& b);

    // Subtract
    Polynomial operator-(const Polynomial& b) const;

    // Subtract (in-place)
    Polynomial& operator-=(const Polynomial& b);

    // Multiply
    Polynomial operator*(const Polynomial& b) const;

    // Multiply (in-place)
    Polynomial& operator*=(const Polynomial& b);

    // Divide by constant
    Polynomial operator/(real_t b) const;

    // Divide by constant (in-place)
    Polynomial& operator/=(real_t b);


  protected:
    std::vector<real_t> p_;
  };

} // namespace casadi


#endif // CASADI_POLYNOMIAL_HPP

